using System;
using System.Diagnostics;
using System.IO;
using System.Threading.Tasks;

using Amazon.Lambda.Core;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.Json.JsonSerializer))]

namespace dump_dotnet8
{
    public class Function
    {
        /// <summary>
        /// Lambda function to dump the container directories /var/lang 
        /// and /var/runtime and upload the resulting archive to S3
        /// </summary>
        /// <returns></returns>
        public string FunctionHandler(object invokeEvent, ILambdaContext context)
        {
            string filename = "dotnet8.tgz";
            string bucket = Environment.GetEnvironmentVariable("BUCKET");
            string cmd = $"lambda-dump -bucket {bucket} -key fs/__ARCH__/{filename}";

            Console.WriteLine($"invokeEvent: {invokeEvent}");
            Console.WriteLine($"context.RemainingTime: {context.RemainingTime}");

            RunShell(cmd);

            return "";
        }

        private static Process RunShell(string cmd)
        {
            var escapedArgs = cmd.Replace("\"", "\\\"");
            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "/bin/sh",
                    Arguments = $"-c \"{escapedArgs}\"",
                    UseShellExecute = false,
                    CreateNoWindow = true,
                }
            };
            process.Start();
            process.WaitForExit();
            return process;
        }
    }
}

require 'pp'

# docker run --rm -v "$PWD":/var/task lambci/lambda:ruby2.5 lambda_function.lambda_handler
# docker run --rm -v "$PWD":/var/task lambci/lambda:ruby2.7 lambda_function.lambda_handler
# docker run --rm -v "$PWD":/var/task lambci/lambda:ruby3.2 lambda_function.lambda_handler

def lambda_handler(event:, context:)
  info = {
    'event' => event,
    'ENV' => ENV.to_hash,
    'context' => context.instance_variables.each_with_object({}) { |k, h| h[k] = context.instance_variable_get k },
    'ps aux' => `bash -O extglob -c 'for cmd in /proc/+([0-9])/cmdline; do echo $cmd; xargs -n 1 -0 < $cmd; done'`,
    'proc environ' => `xargs -n 1 -0 < /proc/1/environ`,
  }

  pp info

  return info
end

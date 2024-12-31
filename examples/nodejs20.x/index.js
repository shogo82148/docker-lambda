// Just a test lambda, run with:
// docker run --rm -v "$PWD":/var/task:ro,delegated ghcr.io/shogo82148/lambda-nodejs:20 index.handle

exports.handler = async (event, context) => {
  console.log(process.execPath);
  console.log(process.execArgv);
  console.log(process.argv);
  console.log(process.cwd());
  console.log(__filename);
  console.log(process.env);
  console.log(process.getuid());
  console.log(process.getgid());
  console.log(process.geteuid());
  console.log(process.getegid());
  console.log(process.getgroups());
  console.log(process.umask());

  console.log(event);

  console.log(context);

  return {};
};

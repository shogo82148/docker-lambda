const { execSync } = require('child_process')

// Depends on dump/layer
exports.handler = async(event, context) => {
  console.log('archiving file system...')

  const bucket = process.env['BUCKET'];
  const cmd = `lambda-dump -bucket ${bucket} -key fs/__ARCH__/nodejs14.x.tgz`
  execSync(cmd, { stdio: 'inherit', maxBuffer: 16 * 1024 * 1024 })

  console.log("process.execPath:", process.execPath)
  console.log("process.execArgv:", process.execArgv)
  console.log("process.argv", process.argv)
  console.log("process.cwd():", process.cwd())
  console.log("__filename:", __filename)
  console.log("process.env:", process.env)
  console.log("context:", context)

  return {}
}

function arch() {
  switch(process.arch) {
    case 'arm64':
      return 'arm64'
    case 'x64':
      return 'x86_64'
  }
  throw new Error(`unknown arch: ${process.arch}`)
}

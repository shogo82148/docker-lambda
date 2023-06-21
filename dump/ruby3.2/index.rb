require 'json'

def handler(event:, context:)
  bucket = ENV['BUCKET']
  puts `lambda-dump -bucket #{bucket} -key fs/__ARCH__/ruby3.2.tgz`

  info = {
    'ENV' => ENV.to_hash,
    'context' => context.instance_variables.each_with_object({}) { |k, h| h[k] = context.instance_variable_get k },
  }

  print JSON.pretty_generate(info)

  return info
end

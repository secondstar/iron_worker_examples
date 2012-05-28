require 'yaml'
require 'iron_worker_ng'
# Create an IronWorker client

config_data = YAML.load_file '../_config.yml'
client = IronWorkerNG::Client.new(:token => config_data['iw']['token'], :project_id => config_data['iw']['project_id'])

code = IronWorkerNG::Code::Ruby.new
code.merge_gem 'aws'
code.merge_gem 'subexec'
code.merge_gem 'mini_magick'
code.merge_worker 'image_processor.rb'

# Upload the code package
client.codes.create(code)

aws = config_data['aws']
client.tasks.create(
    'ImageProcessor',
    image_url: aws['image_url'],
    aws_access: aws['access_key'],
    aws_secret: aws['secret_key'],
    aws_s3_bucket_name: aws['s3_bucket_name'],
)
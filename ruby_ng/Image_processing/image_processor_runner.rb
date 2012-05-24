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

client.tasks.create('ImageProcessor', :aws_access => config_data['aws']['access_key'],:aws_secret => config_data['aws']['secret_key'],:aws_s3_bucket_name => config_data['aws']['s3_bucket_name'],:image_url => config_data['image_url'])
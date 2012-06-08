require 'yaml'
require 'iron_worker_ng'

# Create an IronWorker client
config_data = YAML.load_file '../_config.yml'
client = IronWorkerNG::Client.new()

aws = config_data['aws']
client.tasks.create(
    'ImageProcessor',
    image_url: aws['image_url'],
    aws_access: aws['access_key'],
    aws_secret: aws['secret_key'],
    aws_s3_bucket_name: aws['s3_bucket_name'],
)
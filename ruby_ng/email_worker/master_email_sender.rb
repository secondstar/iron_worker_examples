require 'yaml'
require 'iron_worker_ng'
# Create an IronWorker client

config_data = YAML.load_file '../../ruby/_config.yml'

client = IronWorkerNG::Client.new(:token => config_data['iw']['token'], :project_id => config_data['iw']['project_id'])

client.tasks.create("master_email_worker", config_data)

require 'yaml'
require 'iron_worker_ng'

# loading config from config file
config_data = YAML.load_file '../../ruby/_config.yml'

# Create an IronWorker client
client = IronWorkerNG::Client.new(:token => config_data['iw']['token'], :project_id => config_data['iw']['project_id'])

email = config_data['email']
params = {:username => email['username'],
          :password => email['password'],
          :domain => 'simpleworker.com',
          :from => email['from'],
          :to => [email['to'],email['to']],
          :subject => 'sample',
          :content => 'HEY ITs a body',
          :provider => 'gmail'
}
#launching worker
client.tasks.create("email_worker", params)

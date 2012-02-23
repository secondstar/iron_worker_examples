require 'iron_worker_ng'
require 'yaml'

config = YAML.load_file('../../ruby/_config.yml')

client = IronWorkerNG::Client.new(config['iw']['project_id'], config['iw']['token'])

client.tasks.create('ActionmailerWorker', :gmail => config['gmail'], :from => 'andrew@iron.io', :to => ['andrew@iron.io']) # I like receiving mails

require 'iron_worker_ng'
require_relative '../../ruby/examples_helper'

config = ExamplesHelper.load_config

client = IronWorkerNG::Client.new(config['iw']['project_id'], config['iw']['token'])

client.tasks.create('ActionmailerWorker', :gmail => config['gmail'], :from => 'andrew@iron.io', :to => ['andrew@iron.io']) # I like receiving mails

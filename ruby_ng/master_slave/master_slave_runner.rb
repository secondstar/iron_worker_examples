require 'iron_worker_ng'
require 'yaml'

config = YAML.load_file('../../ruby/_config.yml')

client = IronWorkerNG::Client.new(config['iw']['project_id'], config['iw']['token'])

slaves = {
  'slave one' => {'foo' => 'bar'},
  'slave two' => {'hello' => 'world'}
}

client.tasks.create('MasterWorker', 'slaves' => slaves)

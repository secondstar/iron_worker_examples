require 'iron_worker_ng'
require 'yaml'

config = YAML.load_file('../../ruby/_config.yml')

client = IronWorkerNG::Client.new(config['iw']['project_id'], config['iw']['token'])

# let's queue it now
# note that code package name was guessed from worker name
client.tasks.create('HelloWorker', 'some_param' => 'some_value', 'other_param' => [1, 2, 3])

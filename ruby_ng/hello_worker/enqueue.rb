require 'iron_worker_ng'
require_relative '../../ruby/examples_helper'

config = ExamplesHelper.load_config

client = IronWorkerNG::Client.new(config['iw']['token'], config['iw']['project_id'])

# let's queue it now
# note that code package name was guessed from worker name
client.tasks.create('HelloWorker', 'some_param' => 'some_value', 'other_param' => [1, 2, 3])

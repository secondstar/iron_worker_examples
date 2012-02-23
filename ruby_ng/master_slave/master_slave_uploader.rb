require 'iron_worker_ng'
require 'yaml'

config = YAML.load_file('../../ruby/_config.yml')

client = IronWorkerNG::Client.new(config['iw']['project_id'], config['iw']['token'])

# master code package
master_code = IronWorkerNG::Code::Ruby.new
master_code.merge_worker 'master_worker.rb'
master_code.merge_gem 'iron_worker_ng' # we need it to queue slave workers

# slave code package
slave_code = IronWorkerNG::Code::Ruby.new
slave_code.merge_worker 'slave_worker.rb'

# upload both code packages
client.codes.create(master_code)
client.codes.create(slave_code)

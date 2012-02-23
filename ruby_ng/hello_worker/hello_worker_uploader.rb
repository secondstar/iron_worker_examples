require 'iron_worker_ng'
require 'yaml'

config = YAML.load_file('../../ruby/_config.yml')

client = IronWorkerNG::Client.new(config['iw']['project_id'], config['iw']['token'])

# let's create code package containing our shiny worker...
code = IronWorkerNG::Code::Ruby.new
code.merge_worker 'hello_worker.rb'

# ...and upload it to iron.io cloud
client.codes.create(code)

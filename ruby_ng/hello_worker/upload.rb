require 'iron_worker_ng'
require_relative '../../ruby/examples_helper'

config = ExamplesHelper.load_config

client = IronWorkerNG::Client.new(:token => config['iw']['token'], :project_id => config['iw']['project_id'])

# let's create code package containing our shiny worker...
code = IronWorkerNG::Code::Ruby.new
code.merge_worker 'hello_worker.rb'

# ...and upload it to iron.io cloud
client.codes.create(code)

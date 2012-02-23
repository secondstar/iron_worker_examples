require 'iron_worker_ng'
require_relative '../../ruby/examples_helper'

config = ExamplesHelper.load_config

client = IronWorkerNG::Client.new(config['iw']['token'], config['iw']['project_id'])

code = IronWorkerNG::Code::Ruby.new
code.merge_worker 'github_webhook_worker.rb'
code.merge_file 'webhook_config.yml'
code.merge_gem 'hipchat-api'

client.codes.create(code)

url = "https://worker-aws-us-east-1.iron.io/2/projects/#{config['iw']['project_id']}/tasks/webhook?code_name=#{code.name}&oauth=#{config['iw']['token']}"

puts "Add this url to github Service Hooks, Post Receive URLs: "
puts url

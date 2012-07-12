require 'iron_worker_ng'
require 'yaml'

#IronCore::Logger.logger.level = ::Logger::DEBUG

# Create IronWorker client
client = IronWorkerNG::Client.new

params = YAML.load_file("config.yml")

task = client.tasks.create('HipchatExport', params)

puts "Your task has been queued up, check https://hud.iron.io to see your task status and log or wait for it below..."

result = client.tasks.wait_for(task.id)
p result

log = client.tasks.log(task.id)
puts log

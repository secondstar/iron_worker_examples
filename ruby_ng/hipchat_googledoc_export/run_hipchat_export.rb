require 'iron_worker_ng'

IronCore::Logger.logger.level = ::Logger::DEBUG

# Create IronWorker client
client = IronWorkerNG::Client.new

# Now create/queue a task for the worker
params = {"hipchat_token" => "YOURTOKEN",
          "google_password" => "YOURPASSWORD",
          "google_username" => "YOURUSERNAME"}
task = client.tasks.create('HipchatExport', params)

puts "Your task has been queued up, check https://hud.iron.io to see your task status and log or wait for it below..."

result = client.tasks.wait_for(task.id)
p result

log = client.tasks.log(task.id)
puts log

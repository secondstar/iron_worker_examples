require 'iron_worker_ng'

# Create IronWorker client
client = IronWorkerNG::Client.new

# Now create/queue a task for the worker
client.tasks.create('HelloWorker', 'some_param' => 'some_value', 'other_param' => [1, 2, 3])

puts "Your task has been queued up, check https://hud.iron.io to see your task status and log."

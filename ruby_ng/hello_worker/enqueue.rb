require 'iron_worker_ng'

client = IronWorkerNG::Client.new

# let's queue it now
# note that code package name was guessed from worker name
client.tasks.create('HelloWorker', 'some_param' => 'some_value', 'other_param' => [1, 2, 3])

puts "Now you check http://hud.iron.io to see your task status and log"

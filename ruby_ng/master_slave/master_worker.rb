require 'iron_worker_ng'

client = IronWorkerNG::Client.new(:token => iron_io_token, :project_id => iron_io_project_id) # they are magically available inside worker

puts "Queueing slave workers..."
slaves = params['slaves']
slaves.keys.each do |slave|
  puts "Queueing #{slave} with params #{slaves[slave].inspect}"
  client.tasks.create('SlaveWorker', slaves[slave])
end
puts 'Done'

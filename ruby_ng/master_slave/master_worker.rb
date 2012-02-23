require 'iron_worker_ng'

client = IronWorkerNG::Client.new(@iron_io_project_id, @iron_io_token) # they are magically available inside worker

log "Queueing slave workers..."
slaves = @params['slaves']
slaves.keys.each do |slave|
  log "Queueing #{slave} with params #{slaves[slave].inspect}"
  client.tasks.create('SlaveWorker', slaves[slave])
end
log 'Done'

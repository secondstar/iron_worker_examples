# worker code is common ruby code
# note that 'log' is just using 'puts' so any of your logging code will work

log "Starting HelloWorker at #{Time.now}"
log "We got following params #{params}"
log "Simulating hard work for 10 seconds..."
sleep 10
log "Done running HelloWorker at #{Time.now}"

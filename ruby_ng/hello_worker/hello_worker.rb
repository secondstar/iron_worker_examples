# worker code is common ruby code
# note that 'log' is just using 'puts' so any of your logging code will work

puts "Starting HelloWorker at #{Time.now}"
puts "We got following params #{params}"
puts "Simulating hard work for 10 seconds..."
sleep 10
puts "Done running HelloWorker at #{Time.now}"

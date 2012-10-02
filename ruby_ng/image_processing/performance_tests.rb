ranges = [1, 10, 100, 1000]

def params
  {'disable_network' => true}
end

times = {}
ranges.each do |r|
  system "rm #{r}.csv"
  system "dstat -c -d -m --output #{r}.csv &"
  start_time = Time.now
  r.times do |i|
    puts "Launching:#{i}"
    fork { load 'image_processor.rb' }
  end
  Process.waitall
  system('killall -9 python')
  puts "Processing time = #{Time.now - start_time}"
  times[r] = Time.now - start_time
end

File.open("times.stat", "w") do |file|
  file.write times.to_s
end

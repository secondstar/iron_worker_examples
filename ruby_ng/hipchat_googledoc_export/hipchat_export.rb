require 'active_support/core_ext'
require 'hipchat-api'
require 'google_drive'

####################
#PARAMS
puts params.inspect
hipchat_token = params["hipchat_token"]
google_pass = params["google_password"]
google_user = params["google_usename"]
range_ago = params["range_ago"]
###################


range_ago||=1
session = GoogleDrive.login(google_user, google_pass)
hipchat = HipChat::API.new(hipchat_token)
end_date = Time.now
start_date = end_date - range_ago.month
rooms = hipchat.rooms_list
open_rooms = rooms.to_hash["rooms"].select { |r| !r["is_private"] }
rooms_history = {}

filename = Time.now.strftime('%Y-%m')
file = session.files("title" => filename)

puts "Looking for file: #{filename}"
if file.empty?
  puts "File not found, creating new one!"
  file = session.create_spreadsheet(filename)
else
  puts "File found, let's use it"
  file = file.first
end


open_rooms.each do |room|
  ws = file.worksheet_by_title(room["name"])
  import_from = Time.at(room["created"])
  puts "Looking for a worksheet: #{room["name"]}"
  if ws
    puts "Worksheet found!"
    import_from = Time.parse(ws.list.entries.last["date"]) if ws.list.entries.last
  else
    puts "No such worksheet, creating new"
    ws = file.add_worksheet(room["name"])
    ws.list.keys = ["date", "from", "message"]
    ws.save
  end
  import_from = start_date if start_date > import_from
  puts "Latest timestamp :#{import_from}"
  days_back = ((end_date - import_from)/60/60/24).ceil
  puts "Should look for #{days_back} days back"
  days_back.downto(0) do |i|
    formatted_date = (end_date - i.days).strftime('%y-%m-%d')
    puts "Getting messages #{i} days ago - #{formatted_date}"
    messages = rooms_history[room["name"]]= hipchat.rooms_history(room["name"], formatted_date, 'UTC').parsed_response["messages"]
    puts "Found messages:#{messages.inspect}"
    if messages
      messages.each do |m|
        next if Time.parse(m["date"]) <= import_from
        puts "Pushing message :#{m.inspect}"
        ws.list.push({:date => m["date"], :from => m["from"]["name"], :message => m["message"]})
      end
      ws.save
    end
  end
end

temp_sheet = file.worksheet_by_title('Sheet 1')
temp_sheet.delete if temp_sheet

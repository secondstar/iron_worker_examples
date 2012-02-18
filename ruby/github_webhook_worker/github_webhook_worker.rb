require 'iron_worker'
require 'cgi'

# bump..
class GithubWebhookWorker < IronWorker::Base

  merge_gem 'hipchat-api'

  def run

    puts "hello webhook!  payload: #{IronWorker.payload}"

    payload = IronWorker.payload #["payload=".length, IronWorker.payload.length]

    cgi_parsed = CGI::parse(payload)
    puts "cgi_parsed: " + cgi_parsed.inspect

    parsed = JSON.parse(cgi_parsed["payload"][0])
    puts "parsed: " + parsed.inspect

    hipchat = HipChat::API.new("MY_HIPCHAT_API_KEY")

    parsed["commits"].each do |c|
      puts hipchat.rooms_message("Test Room", 'WebhookWorker', "Rev: <a href=\"#{c["url"]}\">#{c["id"][0,9]}</a> - #{c["message"]}", true).body
    end

  end

end

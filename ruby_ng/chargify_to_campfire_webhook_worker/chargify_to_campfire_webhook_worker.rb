require 'cgi'
require 'yaml'
require 'broach'

# the payload we get from github needs to be decoded first
cgi_parsed = CGI::parse(payload)
puts "cgi_parsed: #{cgi_parsed.inspect}"

# Then we can parse the json
parsed = JSON.parse(cgi_parsed)
puts "parsed: #{parsed.inspect}"

@event = parsed["event"][0]

# Also parse the config we uploaded with this worker for our Hipchat stuff
webhook_config = YAML.load_file('webhook_config.yml')
puts "webhook_config: #{webhook_config.inspect}"

Broach.settings = {
    'account' => webhook_config['account'],
    'token'   => webhook_config['token'],
    'use_ssl' => true
}
Broach.speak(webhook_config['room'], @event)

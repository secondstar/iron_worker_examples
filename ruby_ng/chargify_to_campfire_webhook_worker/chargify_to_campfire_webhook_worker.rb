require 'cgi'
require 'yaml'
require 'broach'

# the payload we get from github needs to be decoded first
cgi_parsed = CGI::parse(payload)
puts "cgi_parsed: #{cgi_parsed.inspect}"

# Then we can parse the json
parsed = JSON.parse(cgi_parsed['payload'][0])
puts "parsed: #{parsed.inspect}"

# Also parse the config we uploaded with this worker for our Hipchat stuff
webhook_config = YAML.load_file('webhook_config.yml')
puts "webhook_config: #{webhook_config.inspect}"

#Broach.settings = {
#    'account' => 'myaccount',
#    'token'   => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
#    'use_ssl' => true
#}
#Broach.speak('Office', 'Manfred just deployed a new version of the weblog (http://www.fngtps.com)')

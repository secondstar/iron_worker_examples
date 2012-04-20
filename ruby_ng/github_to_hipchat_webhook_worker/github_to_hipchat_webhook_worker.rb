require 'cgi'
require 'yaml'
require 'hipchat-api'

cgi_parsed = CGI::parse(payload)
log "cgi_parsed: #{cgi_parsed.inspect}"

parsed = JSON.parse(cgi_parsed['payload'][0])
log "parsed: #{parsed.inspect}"

webhook_config = YAML.load_file('webhook_config.yml')
log "webhook_config: #{webhook_config.inspect}"

hipchat = HipChat::API.new(webhook_config['hipchat']['api_key'])

parsed['commits'].each do |c|
  log hipchat.rooms_message(webhook_config['hipchat']['room'], 'GithubHook', "Rev: <a href=\"#{c['url']}\">#{c['id'][0,9]}</a> - #{c['message']}", true).body
end

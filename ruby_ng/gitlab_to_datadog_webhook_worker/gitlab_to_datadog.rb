require 'dogapi'
require 'yaml'
require 'json'

datadog_config = YAML.load_file('datadog.yml')

c_list = ""

if params['total_commits_count'] > 0
    c_list = "#{params['total_commits_count']}\n"
    params['commits'].each do |commit|
        c_list = c_list + "\t#{commit['id'][0..7]} #{commit['message']}\n"
    end

else
    c_list = "0"
end

code_info = <<-eos
    Code push by: #{params['user_name']}
    Repository: #{params['repository']['name']}  
eos


msg = code_info + "Commits: #{c_list}"

dog = Dogapi::Client.new(datadog_config['datadog']['api_key'])
dog.emit_event(
    Dogapi::Event.new(msg,
        :msg_title=>'Code Push',
        :alert_type=>'success',
        :source_type_name=>'my apps',
        :tags=>['gitlab']
))

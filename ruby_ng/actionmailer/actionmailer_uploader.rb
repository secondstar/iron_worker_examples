require 'iron_worker_ng'
require 'yaml'

config = YAML.load_file('../../ruby/_config.yml')

client = IronWorkerNG::Client.new(config['iw']['project_id'], config['iw']['token'])

code = IronWorkerNG::Code::Ruby.new
code.merge_worker 'actionmailer_worker.rb'
code.merge_file 'mailer.rb' # merging mailer...
code.merge_dir 'mailer' # ...and templates
code.merge_gem 'actionmailer' # we need actionmailer gem merged as well

client.codes.create(code)

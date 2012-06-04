require 'iron_mq'
require 'iron_worker_ng'
# Create an IronWorker client
def queue_worker(config_data, to, subject, content)
  client = IronWorkerNG::Client.new(:token => config_data['iw']['token'], :project_id => config_data['iw']['project_id'])
  email = config_data['email']
  params = {:username => email['username'],
            :password => email['password'],
            :domain => email['domain'],
            :from => email['from'],
            :to => to,
            :subject => subject,
            :content => content,
            :provider => email['provider']}
  client.tasks.create("email_worker", params)
end

def get_emails(config_data)
  ironmq = IronMQ::Client.new(:token => config_data['iw']['token'], :project_id => config_data['iw']['project_id'])
  emails = []
  n = 0
  while n < 100 # 100 emails per single run
    msg = ironmq.messages.get()
    break unless msg
    emails << msg.body
    msg.delete
    n+=1
  end
  emails
end

def content
  <<-EOF
  <h1>Thank you for using Iron Worker</h1>
It's a simple email that has some html tags<br>
  <a href='http://iron.io'>Iron.io</a>
  EOF
end

emails = get_emails(params)

emails.each do |email|
  queue_worker(params, email, "Welcome email", content)
end

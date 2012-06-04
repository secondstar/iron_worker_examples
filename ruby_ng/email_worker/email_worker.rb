# Configures smtp settings to send email.
def init_mail(username, password, domain, provider)
  case provider
    when 'gmail'
      port = 587
      address = "smtp.gmail.com"
    else #sendgrid
      port = 25
      address = "smtp.sendgrid.net"
  end
  mail_conf = {:address => address,
               :port => port,
               :domain => domain,
               :user_name => username,
               :password => password,
               :authentication => 'plain',
               :enable_starttls_auto => true}
  Mail.defaults do
    delivery_method :smtp, mail_conf
  end
end

def send_mail(to, from, subject, content)
  msg = Mail.new do
    to to
    from from
    subject subject
    html_part do |m|
      content_type 'text/html'
      body content
    end
  end
  msg.deliver
end


# Sample worker that sends an email.

require 'mail'

init_mail(params['username'], params['password'], params['domain'], params['provider'])

send_mail(params['to'], params['from'], params['subject'], params['content'])

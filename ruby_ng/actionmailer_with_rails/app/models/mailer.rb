class Mailer < ActionMailer::Base
  layout 'email'
  default :from => "chad@iron.io"

  def hello_world(email)
    mail(:to => email,
         :subject => "Hello World from IronWorker!")
  end

end

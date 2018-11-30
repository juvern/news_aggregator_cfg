require 'pony'

Pony.options = { :via => 'smtp', 
                 :via_options => {
                   :address => 'smtp.mailgun.org', 
                   :port => '587',
                   :enable_starttls_auto => true, 
                   :authentication => :plain,
                   :user_name => 'postmaster@sandbox79a509272013404ea5bd4c9a63c3e150.mailgun.org', 
                   :password => '71f8546b1d960922cc7aa3c27434af8f-21e977f8-a7288a03' 
                 }
               }

message = {

  :from => 'chloealicelane@virginmedia.com>',

  :to => 'Chloe <',
  :subject => 'Welcome!',

  :body => 'Thanks for signing up to our awesome newsletter!'

}

Pony.mail(message)
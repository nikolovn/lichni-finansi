# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Finance::Application.initialize!


ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
   :tls => true,
   :address => "mail.lichni-finansi.info",
   :port => 26,
   :domain => "lichni-finansi.info",
   :authentication => :login,
   :user_name => "info@lichni-finansi.info",
   :password => "O@DykpH&7g5J"
 }
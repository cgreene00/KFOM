# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => ENV['GMAIL_USERNAME'],
  :password => ENV['GMAIL_PASSWORD'],
  :domain => 'kfom.org',
  :address => 'smtp.gmail.com',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}

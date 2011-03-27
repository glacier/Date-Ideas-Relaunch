# According to Railscast 306, put settings here, but this doesn't work
# Refer to http://guides.rubyonrails.org/action_mailer_basics.html instead

# ActionMailer::Base.smtp_settings = {
#   :address => "smtp.gmail.com",
#   :port => 587,
#   :domain => "gmail.com",
#   :user_name => "fullofgrace88",
#   :password => "w4Q!0ing05",
#   :authentication => :login,
#   :enable_starttls_auto => true
# }

# ActionMailer::Base.default_url_options[:host] = "localhost:3000"

# intercept email and make it go to grace@dateideas.ca if server is in development mode
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?

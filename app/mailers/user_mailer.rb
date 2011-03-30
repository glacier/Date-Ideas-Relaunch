class UserMailer < ActionMailer::Base
  default :from => "no-reply@dateideas.ca"
  
  def date_plan_email(user, datecart)
    @user = user
    @datecart = datecart
    mail(:to => "#{user.first_name} #{user.last_name} <#{user.email}>", :subject => "dateideas.ca: Your Date Plan")
  end
end

# lib/development_mail_interceptor.rb
class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject}"
    message.to = "fakeaccount@mailinator.com"
  end
end
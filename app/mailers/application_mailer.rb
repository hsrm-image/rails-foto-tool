class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.x.mail.sender_address
  layout 'mailer'
end

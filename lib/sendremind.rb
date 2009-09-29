require File.dirname(__FILE__) + '/../config/environment'
require 'application'

events = Event.find_by_delivery

ApplicationController.logger.info "starting send mail proc"

events.each {|event|
  
  hcalendar = ApiMfps.specific_request_all(event.html)
  
  next if hcalendar == nil
  
  auth_email = AuthEmail.find_by_auth_id(event.auth_email_id)
  next if auth_email == nil

  begin
    if auth_email.mobile?
      ApplicationController.logger.info "send to mobile #{auth_email.mail_address}"
      Mailer.deliver_remind_mobile(hcalendar, auth_email.mail_address)
    else
      ApplicationController.logger.info "send to #{auth_email.mail_address}"
      Mailer.deliver_remind(hcalendar, auth_email.mail_address)
    end
    
    event.delivered_flag = true
    event.save!
  rescue => e
     ApplicationController.logger.error "can't sending mail :#{e}"
  end
}

ApplicationController.logger.info "end send mail proc"
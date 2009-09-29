
class Mailer < Iso2022jpMailer
  helper :dateFormat
  
  MAIL_WELCOME = "welcome@#{APP_CONFIG[:domain]}"
  MAIL_INVITATION = "invitation@#{APP_CONFIG[:domain]}"
  
  def first_auth(user_info, auth_info, sent_at = Time.now)
    @subject    = "#{base64('ぼくこよ ご利用ありがとうございます。')}"
    @recipients = user_info.email
    @from       = "#{base64('ぼくこよ')}<#{MAIL_WELCOME}>"
    @sent_on    = sent_at
    @headers    = {}
    
    body :user_info => user_info, :auth_info => auth_info
    
  end
  
  def first_auth_mobile(auth_info, sent_at = Time.now)
    @subject    = "#{base64('ぼくこよ ご利用ありがとうございます。')}"
    @recipients = auth_info.mail_address
    @from       = "#{base64('ぼくこよ')}<#{MAIL_WELCOME}>"
    @sent_on    = sent_at
    @headers    = {}
    
    body :auth_info => auth_info
  end
  
  def regist_mobile(auth_info, sent_at = Time.now)
    @subject    = "#{base64('ぼくこよ ご利用ありがとうございます。')}"
    @recipients = auth_info.mail_address
    @from       = "#{base64('ぼくこよ')}<#{MAIL_WELCOME}>"
    @sent_on    = sent_at
    @headers    = {}
    
    body :auth_info => auth_info
  end
  
  def authed_mobile(auth_info, sent_at = Time.now)
    @subject    = "#{base64('ぼくこよ ご利用ありがとうございます。')}"
    @recipients = auth_info.mail_address
    @from       = "#{base64('ぼくこよ')}<#{MAIL_WELCOME}>"
    @sent_on    = sent_at
    @headers    = {}
    
    body :auth_info => auth_info
  end
  
  def remind(hCalendar, email, sent_at = Time.now)
     title = "ぼくこよ #{email}さんからの招待状"
     @subject    = "#{base64(title)}"
     @recipients = email
     @from       = "#{base64('ぼくこよ')}<#{MAIL_INVITATION}>"
     @sent_on    = sent_at
     @headers    = {}
     
     body :hCalendar => hCalendar, :recipients => @recipients
  end
   
  def remind_mobile(hCalendar, email, sent_at = Time.now)
    title = "ぼくこよ #{email}さんからの招待状"
    @subject    = "#{base64(title)}"
    @recipients = email
    @from       = "#{base64('ぼくこよ')}<#{MAIL_INVITATION}>"
    @sent_on    = sent_at
    @headers    = {}

    body :hCalendar => hCalendar, :recipients => @recipients
  end
  
  def receive(email)
    from = email.from_addrs.first.spec.strip
    if email.subject == 'BokukoyoMobileRegist' 
      auth_email = AuthEmail.find_by_mail_address(from)
      if auth_email.nil?
        auth_email = AuthEmail.new.setup_auth(from)
        auth_email.save
      else
        auth_email.setup_auth(from)
        auth_email.update
      end
      Mailer.deliver_regist_mobile(auth_email)
    end
  end
end

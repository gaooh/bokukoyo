require 'nkf'

class Iso2022jpMailer < ActionMailer::Base
  @@default_charset = 'ISO-2022-JP'
  @@encode_subject = false
  
  def base64(text)
    if default_charset == 'ISO-2022-JP'
      text = NKF.nkf('-Wj -m0',text)
    end
    text = [text].pack('m').delete("\r\n")
    "=?#{default_charset}?B?#{text}?="
  end
  
  def create!(*)
    super
    
    @mail.body = NKF::nkf('-Wjx -m0',@mail.body)
    return @mail
  end

  alias :_create_mail :create_mail
  def create_mail
    @parts.each do |part|
      part.transfer_encoding = @@default_charset
      part.body = NKF::nkf('-Wj -m0 -x', part.body)
    end
    _create_mail
  end
    
end
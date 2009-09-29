#
# table auth_emails:
#  メールアドレス　        mail_address, :string, :limit => 256, :null => false
#  ブックマークレット用コード　  bk_code, :string, :limit => 32, :null=>true
#  認証コード　          invite_code, :string, :limit => 32, :null=>false 
#  認証フラグ　          auth_flag, :boolean, :defalut => false, :null => false
#  生成日　            created_at, :datetime
#  停止フラグ　          stop_flag, :boolean, :default=> false #　強制的に送信停止にする
#
# Author::    asami@drecom.co.jp
# Copyright:: Copyright(C) 2006 Drecom Co., Ltd. All Rights Reserved.

class AuthEmail < ActiveRecord::Base

  #=== find_by_auth_id
  # 認証済みののAuthEmailを検索。
  def self.find_by_auth_id(id)
    find(:first, :conditions=>["id = ? and auth_flag = true and stop_flag = false", id])
  end
    
  def setup_auth(email)
    self.mail_address = email
    self.bk_code = Util.random_string(32)
    self.invite_code = Util.random_string(32)
    self.auth_flag = false
    self.stop_flag = false
    self.created_at = Time.new
  end
  
  def send_auth_mail(user_info)
    if mobile?
      Mailer.deliver_first_auth_mobile(self)
    else
      Mailer.deliver_first_auth(user_info, self)
    end
  end
  
  #=== mobile?
  # 携帯のメールアドレスかどうか  
  def mobile?
    domain = self.mail_address.split("@")[1]
    if !domain.scan(/docomo(-camera)?\.ne\.jp/).empty?
      true # docomo
    elsif !domain.scan(/.*vodafone\.ne\.jp/).empty?
      true # vodafone
    elsif !domain.scan(/.*ez(web|.*ido)\.ne\.jp/).empty?
      true # au
    elsif !domain.scan(/.*softbank\.ne\.jp/).empty?
      true # softbank
    elsif !domain.scan(/.*(tu-ka|tkk|tkc)\.ne\.jp/).empty?
      true
    elsif !domain.scan(/.*pdx\.ne\.jp/).empty?
      true
    elsif !domain.scan(/.*jp-[a-z]\.ne\.jp/).empty?
      true
    elsif !domain.scan(/.*nttpnet\.ne\.jp/).empty?
      true
    elsif !domain.scan(/.*(phone|mozio)\.ne\.jp/).empty?
      true
    else
      false
    end
  end
end

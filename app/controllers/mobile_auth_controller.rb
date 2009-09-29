class MobileAuthController < ApplicationController
  mobile_filter
  layout 'mobile'
  helper :mobile
  
  def setup
    id = params[:id]
    
    auth_email = AuthEmail.find_by_invite_code(id)
    if auth_email == nil
      flash[:notice] = '有効な認証URLではありません。' 
      render :controllor=>"mobile_auth", :action=>"error"
    else
      @email = auth_email.mail_address
    end
  end
  
  def regist
    debug ("requet mobile: #{request.mobile}")
    
   if request.mobile.ident != nil
      auth_email = AuthEmail.find_by_mail_address(params[:user_info][:email])
      auth_email.auth_flag = true
      auth_email.save
    
      mobile = Mobile.new
      mobile.ident = request.mobile.ident
      mobile.auth_email_id = auth_email.id
      mobile.nickname = params[:user_info][:nickname]
      mobile.str_remind_day(params[:user_info][:remind_day])
      mobile.remind_time = params[:user_info][:remind_time]
      mobile.create_at = Time.now
      mobile.create
    else 
      flash[:notice] = '登録コードを取得できませんでした。。' 
      render :controllor=>"mobile_auth", :action=>"error"
    end
    
  end
end

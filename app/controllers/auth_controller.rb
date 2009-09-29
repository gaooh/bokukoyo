class AuthController < ApplicationController
  mobile_filter
  layout :basic_layout
  helper :mobile
  
  def regist
    id = params[:id]
    
    auth_email = AuthEmail.find_by_invite_code(id)
    if auth_email == nil
      flash[:notice] = '有効な認証URLではありません。' 
      render :action=>"error"
    elsif auth_email.auth_flag 
      flash[:notice] = 'この携帯は登録済みです。'
      render :action=>"error"
    else
      auth_email.auth_flag = true
      auth_email.save
    end
  end
end

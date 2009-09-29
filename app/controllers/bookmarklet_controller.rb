class BookmarkletController < ApplicationController
  layout 'basic'
  helper :post
  
  def entry
    @user_info = UserInfo.new
    @user_info.restore_from_cookies(cookies)
    @read_terms = cookies[:bokukoyo_user_info_read_terms]
    
    @memo = params[:memo]
  end
  
end

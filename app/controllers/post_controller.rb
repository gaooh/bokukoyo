class PostController < ApplicationController
  layout 'basic'
  before_filter :redirect_if_mobile
  after_filter :defalut_charset
  helper :niceform
  
  VIEW_LIST_SIZE = 10
  GET_LIST_SIZE = VIEW_LIST_SIZE + 1
  
  def redirect_if_mobile
    if request.mobile?
       pa = params.dup
       pa[:controller] = "/mobile"
       redirect_to pa
    end
  end
  
  #=== top
  # ポータル表示
  def top
   setup_userinfo

   @pubilc_evnet = Event.find_by_public_event_count
   @events = Event.find_public_evnet(VIEW_LIST_SIZE)
   @hCalendars = HCalendar.marge_events(@events)
   
  end
  
  #=== list
  # 招待状リストのみのページ
  def list
    setup_userinfo
     
    @pubilc_evnet = Event.find_by_public_event_count
    @events = Event.find_public_evnet(VIEW_LIST_SIZE)
    @hCalendars = HCalendar.marge_events(@events)
  end

  #=== next_load
  # listページでのページ送り。RJS  
  def next_load
    @pagenum = params[:pagenum]
    offset = @pagenum.to_i * VIEW_LIST_SIZE
    @events = Event.find_public_evnet(GET_LIST_SIZE, offset)
    if @events.length == GET_LIST_SIZE 
      @events.delete_at(GET_LIST_SIZE)
      @has_next = true
    else
      @has_next = false
    end
    @hCalendars = HCalendar.marge_events(@events)
  end
  
  def posting
    @err_messages = Hash.new
    
    @user_info = UserInfo.new(params[:user_info])
    if params[:user_info][:eat_cookie].nil?
      @user_info.destory_cookies(cookies)
    else 
      @user_info.save_for_cookies(cookies)
    end
    
    @read_terms = cookies[:bokukoyo_user_info_read_terms]
    
    if @read_terms.nil? && params[:user_info][:read_terms].nil?
      @err_messages[:read_terms] = "利用規約に同意していないため登録できません。"
      return 
    end
    
    @hCalendar = HCalendar.new(params[:hCalendar])
    @hCalendar.categories = params[:tags][:tag].split(",")
    @hCalendar.dtstart = params[:dtstart]
    @hCalendar.dtend = params[:dtend]
    @hCalendar.uid = params[:user_info][:nickname]
    
    valid_flag = true
    unless @user_info.valid? 
      @user_info.errors.each { |error| @err_messages["#{error[0]}"] = "#{error[1]}" }
      valid_flag = false
    end
    
    unless @hCalendar.valid? 
      @hCalendar.errors.each { |error| @err_messages["#{error[0]}"] = "#{error[1]}" }
      valid_flag = false
    end
    
    return unless valid_flag 
    
    # 認証メール送信
    auth_email = send_auth_mail(@user_info, params[:user_info][:email])
   
    # microformats html 生成
    filename = @hCalendar.to_html
    @hCalendar.fromurl = "#{APP_CONFIG[:hcalendar_url]}#{filename}"
    
    # 保存
    if params[:event][:public_flag] == "on"
      public_flag = true
    else
      public_flag = false
    end
     
    event = Event.new({
      :public_flag => public_flag, :auth_email_id=>auth_email.id, :html => filename, 
      :delivery_at=>@user_info.remind_datetime(@hCalendar.dtstart), :post_at => Time.now, :delivered_flag => false})
    event.create
    @hCalendar.update_date = event.post_at
    
    # MFPS へping
    @hCalendar.ping(event.html) 
    
    @view_flag = event.public_flag
    if !params[:type].nil? && params[:type] == 'list'
      @view_flag = false
    end
    
  end
  
  #=== privacy
  # プライバシーポリシー 
  def privacy
  end
  
  #=== terms
  # 利用規約
  def terms
  end
  
  private
  def send_auth_mail(user_info, email)
   auth_email = AuthEmail.find_by_mail_address(email)
   
   if auth_email.nil? 
      auth_email = AuthEmail.new
      auth_email.setup_auth(email)
      auth_email.save
      auth_email.send_auth_mail(@user_info) 

   elsif !auth_email.auth_flag # 認証されていなかったら
      auth_email.setup_auth(email)
      auth_email.update
      auth_email.send_auth_mail(@user_info) 
   end
   
   return auth_email
  end
end

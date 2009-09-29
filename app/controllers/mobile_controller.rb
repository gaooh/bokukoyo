
class MobileController < ApplicationController
  mobile_filter
  helper :userinfo
  
  #=== top
  # ポータル表示
  def top
    @events_pages, @events = paginate(:event, :per_page => 3, :conditions=>["public_flag = true"], :order_by => 'post_at DESC')
    @hCalendars = HCalendar.marge_events(@events)
  end
  
  def detail
    @hCalendar = ApiMfps.specific_request("#{params[:id]}.html")
  end

  def ident_reg
  end
  
  def ident_cancel_confirm
  end
  
  def ident_cancel
    ident = request.mobile.ident
    if ident == nil
      flash[:notice] = '端末コードを取得できませんでした。'
      render :action=>"error"
    else
      mobile = Mobile.find_by_ident(ident)
      if mobile == nil
        flash[:notice] = 'ご利用の端末は端末コードの登録がされていません。'
        render :action=>"error"
      else
        Mobile.delete(mobile.id)
      end
    end
  end
  
  #=== entry
  # イベント登録 
  def entry
    @hCalendar = HCalendar.new
    @messages = Hash.new
    user_mobile_info
  end
  
  #=== join
  # ぼくもいくボタン
  def join
    @hCalendar = ApiMfps.specific_request(params[:hCalendar][:fromhtml])
    user_mobile_info
    
    @messages = Hash.new
    render :action=>"entry"
  end
  
  def posting
    @user_info = UserInfo.new(params[:user_info])
    @user_info.read_terms = true
    @user_info.eat_cookie = true 
    
    @hCalendar = HCalendar.new(params[:hCalendar])
    @hCalendar.daytime2dtstart(params[:dtstart][:day], params[:dtstart][:time])
    @hCalendar.daytime2dtend(params[:dtend][:day], params[:dtend][:time])
    @hCalendar.categories = params[:tags][:tag].split(",")
    @hCalendar.uid = params[:user_info][:nickname]
    
    @messages = Hash.new
    unless @user_info.valid? 
      @user_info.errors.each { |error| @messages["#{error[0]}"] = "#{error[1]}<br>" }
    end

    unless @hCalendar.valid?
      @hCalendar.errors.each { |error| @messages["#{error[0]}"] = "#{error[1]}<br>" }
    end
      
    unless @messages.empty?
      user_mobile_info
      render :action=>"entry"
      return 
    end
    
    # 認証メール送信
    auth_email = send_auth_mail(@user_info, params[:user_info][:email])

    # microformats html 生成
    filename = @hCalendar.to_html

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
    
    # MFPS へping
    @hCalendar.ping(filename)
  end
  
  def imahima
    target_day = Date.today.strftime("%Y-%m-%d")
    hima(target_day)
    
    render :action=>"hima"
  end
  
  def asuhima
    target_day = Date.today.next.strftime("%Y-%m-%d")
    hima(target_day)
    
    render :action=>"hima"
  end
  
  def matuhima
    day = Date.today
    wday = day.wday
    randam = rand(1) # 土、日どちらかはランダム
    
    if wday == 0 || wday == 6 #今日が週末
      day = day + randam
    else # 今日は平日
      wcount = 6 - wday + randam
      day = day + wcount
    end
    target_day = day.strftime("%Y-%m-%d")
    hima(target_day)
    
    render :action=>"hima"
  end
  
  def privacy
  end
   
  def terms
  end

  private
  
  def user_mobile_info
    @mobile = Mobile.new
    @email = ""
    
    unless request.mobile.ident.nil?
      @mobile = Mobile.find_by_ident(request.mobile.ident)
      if @mobile.nil?
        @mobile = Mobile.new
      else 
        auth_email = AuthEmail.find_by_id(@mobile.auth_email_id)
        @email = auth_email.mail_address if auth_email.nil?
      end
    end
  end
  
  def hima(day)
   hCalendars = ApiMfps.request({:dtstart=>day, :max=>30})
   return if hCalendars == nil || hCalendars.empty?
   
   start_pos = rand(hCalendars.size)
   cur = start_pos
   event = nil
   0.upto(hCalendars.size) {|i|
     @hCalendar = hCalendars[cur]
     event = Event.find_by_html(@hCalendar.fromhtml)
     break if event != nil && event.public_flag
     cur += 1 if cur <= hCalendars.size
     cur = 0 if cur > hCalendars.size
   }
   if event == nil || !event.public_flag
     @hCalendar = nil
   end
   
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

require 'googlecalendar/service'
require 'googlecalendar/event'
require 'googlecalendar/calendar'
require 'rexml/document'

class GcalendarController < ApplicationController
  layout 'modal'
  helper :niceform
  after_filter :defalut_charset
  
  def regist
    @fromurl = params[:id]
  end
  
  def create
    mail = params[:mail]
    passwd = params[:passwd]
    @fromurl = "#{params[:fromurl]}.html"
    
    if mail == nil || mail == ''
      @error_message = "メールアドレスは必須項目です。"
      @error = true
      render :action=>"regist"
      return 
    end
  
    if passwd == nil || passwd == ''
      @error_message = "パスワードは必須項目です。"
      @error = true
      render :action=>"regist"
      return 
    end
    
    hCalendar = ApiMfps.specific_request(@fromurl)
    if hCalendar == nil
      @error_message = "情報の取得に失敗しました。"
      @error = true
      render :action=>"regist"
      return
    end 
    
    feed = "http://www.google.com/calendar/feeds/" + mail + "/private/full"
    
    srv = GoogleCalendar::Service.new(mail, passwd)
    cal = GoogleCalendar::Calendar.new(srv, feed)
    event = cal.create_event
    event.title = hCalendar.summary
    event.desc = hCalendar.description
    event.where = hCalendar.location
    event.st = Time.parse(hCalendar.dtstart)
    event.en = Time.parse(hCalendar.dtend)
    event.save!
    
    @error = false
  end
  
end

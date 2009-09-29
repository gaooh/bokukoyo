require 'nkf'
# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  helper :DateFormat
  session :disabled => true
  
  def defalut_charset
    headers["Content-Type"] ||= "text/html; charset=utf-8"
  end
    
  def to_rss
    headers["Content-Type"] = 'application/xml; charset=UTF-8'
  end
  
  def to_calendar
    headers["Content-Type"] = "text/calendar; charset=utf-8"
    response.headers["Content-Disposition"] = %Q|attachment; filename="event.ics"|
  end
  
  def basic_layout
    if request.mobile?
      "mobile"
    else
      'basic'
    end
  end
  
  def setup_userinfo
   @user_info = UserInfo.new
   @user_info.restore_from_cookies(cookies)
   @read_terms = cookies[:bokukoyo_user_info_read_terms]
  end
  
  def debug(message)
    logger.debug("[bokukoyo]: #{message}")
  end

  def info(message)
    logger.info("[bokukoyo]: #{message}")
  end

  def error(message)
    logger.error("[bokukoyo]: #{message}")
  end
  
end
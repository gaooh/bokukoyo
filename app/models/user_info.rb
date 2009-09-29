class UserInfo < ActiveForm 
    
  attr_accessor :nickname, :email, :remind_day, :remind_time, :eat_cookie, :read_terms
  validates_presence_of :nickname, :email, :remind_day, :remind_time, :read_terms, :message => "必須入力です。"
  validates_length_of :nickname, :maximum=>32
  validates_length_of :email, :maximum=>256
  validates_format_of :email, :with => /^[\w\W]+@[\w\W]+$/, :message => "Emailの形式として正しくありません。"
  
  def restore_from_cookies(cookies)
    @nickname = cookies[:bokukoyo_user_info_nickname]
    @email = cookies[:bokukoyo_user_info_email]
    @remind_day = cookies[:bokukoyo_user_info_remind_day]
    @remind_time = cookies[:bokukoyo_user_info_remind_time]
    @eat_cookie = cookies[:bokukoyo_user_info_eat_cookie]
    @read_terms = "true" # cookieがある == 利用規約同意済み
  end

  def save_for_cookies(cookies)
    @eat_cookie = "true"
    @read_terms = "true"
    
    set_cookie(cookies, :bokukoyo_user_info_nickname, @nickname)
    set_cookie(cookies, :bokukoyo_user_info_email, @email)
    set_cookie(cookies, :bokukoyo_user_info_remind_day, @remind_day)
    set_cookie(cookies, :bokukoyo_user_info_remind_time, @remind_time)
    set_cookie(cookies, :bokukoyo_user_info_eat_cookie, @eat_cookie)
    set_cookie(cookies, :bokukoyo_user_info_read_terms, @read_terms)
  end
  
  def destory_cookies(cookies)
    destory_cookie(cookies, :bokukoyo_user_info_nickname)
    destory_cookie(cookies, :bokukoyo_user_info_email)
    destory_cookie(cookies, :bokukoyo_user_info_remind_day)
    destory_cookie(cookies, :bokukoyo_user_info_remind_time)
    destory_cookie(cookies, :bokukoyo_user_info_eat_cookie)
    destory_cookie(cookies, :bokukoyo_user_info_read_terms)
  end
  
  def remind_datetime(dtstart)
    return helper_remind_datetime(dtstart.year.to_i, dtstart.month.to_i, dtstart.day.to_i)
  end
  
  private
  def helper_remind_datetime(year, month, day)
    
    if self.remind_time == "9-12"
      remind_datetime = DateTime.new(year, month, day, 9, 0, 0)
    elsif self.remind_time == "12-15"
      remind_datetime = DateTime.new(year, month, day, 12, 0, 0)
    elsif self.remind_time == "15-18"
      remind_datetime = DateTime.new(year, month, day, 15, 0, 0)
    elsif self.remind_time == "18-21"
      remind_datetime = DateTime.new(year, month, day, 18, 0, 0)
    end
    
    if self.remind_day == "previous" # 前日
      remind_datetime = remind_datetime - 1
    end
  
    return remind_datetime
  end
  
  private
  def set_cookie(cookies, key, param)
    cookies[key] = {
      :value => param,
      :domain => APP_CONFIG[:domain],
      :expires => 30.days.from_now
    }
  end
  
  private 
  def destory_cookie(cookies, key)
    cookies[key] = {
      :value =>"", 
      :domain => APP_CONFIG[:domain], 
      :expires => Time.at(0) 
    }
  end
end
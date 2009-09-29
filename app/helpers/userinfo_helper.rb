module UserinfoHelper
  
  def remind_day_check(info, value)
    "checked" if checked?(info, value, -1)
  end
  
  def remind_time_check(info, value)
    "checked" if checked?(info, value, '9-12')
  end
  
  def remind_day_checked?(info, value)
    checked?(info, value, 'previous')
  end
  
  def remind_time_checked?(info, value)
    checked?(info, value, '9-12')
  end
  
  private
  def checked?(info, value, default_value)
    if info.nil? && value == default_value
      return true
    end
    
    if !info.nil? && info == value
      return true
    end
    
    return false
  end
  
end
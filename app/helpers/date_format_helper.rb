module DateFormatHelper
  
  def ical(time)
    time.strftime "%Y%m%dT%H%M%S" if time != nil
  end

  def gcal(time)
    time.strftime "%Y%m%dT%H%M%SZ" if time != nil
  end

  def ja_format_day(dt)
    return "#{dt.year}年#{dt.month}月#{dt.day}日"
  end

  def ja_format_time(dt)
    return "#{sprintf("%02d", dt.hour)}:#{sprintf("%02d", dt.minute)}"
  end
  
  def ja_format(dt)
    return "#{dt.year}年#{dt.month}月#{dt.day}日 #{sprintf("%02d", dt.hour)}:#{sprintf("%02d", dt.minute)}"
  end
  
  def ja_format_short(dt)
    return "#{dt.year}年#{dt.month}月#{dt.day}日#{sprintf("%02d", dt.hour)}:#{sprintf("%02d", dt.minute)}"
  end
  
  def ja_format_simple(dt)
    return "#{dt.month}月#{dt.day}日&nbsp;#{sprintf("%02d", dt.hour)}:#{sprintf("%02d", dt.minute)}"
  end

end
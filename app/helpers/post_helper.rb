module PostHelper 
  
  def style_by_dtstart(dtstart)
    event_style(dtstart.hour.to_i)
  end
  
  def event_style(hour)
    if hour >= 0 && hour <= 6
      1
    elsif hour > 6 && hour <= 11
      2
    elsif hour > 11 && hour <= 16
      3
    elsif hour > 16 && hour <= 20
      4
    elsif hour > 20 && hour <= 24
      5
    end
  end
  
  def truncate_min(date)
    leading_zero_on_single_digits((date.min / 10).floor * 10)
  end
  
  def select_options_year_div(number, key, startyear, endyear, div = {})
    count = 0
    html = ""
    startyear.upto(endyear) { |year|
      html += "<p><a href=\"javascript:showOptions(#{number}); selectMe('#{key}',#{count},#{number});\">#{year}</a></p>"
      count += 1
    }
    select_div(number, html, div)
  end

  def select_options_month_div(number, key, div = {})
    html = ""
    1.upto(12) do |month_number|
      html += "<p><a href=\"javascript:showOptions(#{number}); selectMe('#{key}',#{month_number-1},#{number});\">#{month_number}</a></p>"
    end
    select_div(number, html, div)
  end

  def select_options_day_div(number, key, div = {})
    html = ""
    1.upto(31) do |day|
      html += "<p><a href=\"javascript:showOptions(#{number}); selectMe('#{key}',#{day-1},#{number});\">#{day}</a></p>"
    end
    select_div(number, html, div)
  end
  
  def select_options_hour_div(number, key, div = {})
    html = ""
    0.upto(23) do |hour|
      html += "<p><a href=\"javascript:showOptions(#{number}); selectMe('#{key}',#{hour},#{number});\">#{leading_zero_on_single_digits(hour)}</a></p>"
    end
    select_div(number, html, div)
  end

  def select_options_minute_div(number, key, step, div = {})
    html = ""
    count = 0
    0.step(59, step || 1) do |minute|
      html += "<p><a href=\"javascript:showOptions(#{number}); selectMe('#{key}',#{count},#{number});\">#{leading_zero_on_single_digits(minute)}</a></p>"
      count+=1
    end
    select_div(number, html, div)
  end
  
  def select_div(number, value, div ={})
    select_div = "<div id=\"optionsDiv#{number}\" class=\"optionsDivInvisible\" style=\"#{div[:style]}\">"
    select_div << value
    select_div << "</div>"
  end

  def action_url(hCalendar)
    url = ""
    url << "http://www.google.com/calendar/event?action=TEMPLATE"
    url << "&text=#{hCalendar.summary}"
    url << "&dates=#{gcal(hCalendar.dtstart.utc_time)}/#{gcal(hCalendar.dtend.utc_time)}"
    url << "&location=#{hCalendar.location}"
    url << "&details=#{hCalendar.description}"
    url << "&trp=false"
    url << "&sprop=:#{hCalendar.url}";
    return url
  end
  
  def defalut_day_list
    defalut_day_list = ""
    10.times { |count|
      day = Date.today - 5 + count
      defalut_day_list << "<span class=\"calendar-"
      defalut_day_list << "un" if count != 5
      defalut_day_list << "select\">#{day.day}</span>"
      defalut_day_list << "|" if count != 9
    }
    return defalut_day_list
  end
  
  def li_scales
    li_scales = ""
    10.times { |count|
      li_scales << "<li id=\"li-Scale-#{count}\"><a href=\"#\" title=\"#{count}\"><span>■</span></a></li>"
    }
    return li_scales
  end
end

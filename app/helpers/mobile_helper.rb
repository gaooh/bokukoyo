module MobileHelper
  
  def mobile_image_tag(source, options = {})
  	image_tag("mobile/#{source}", options)
  end
  
  def reg_address
    "reg@#{APP_CONFIG[:domain]}"
  end
  
  def show_dt_day(dt)
    dt.str_day unless dt.nil?
  end
  
  def show_dt_time(dt)
    dt.str_time unless dt.nil?
  end
  
  def warning_message(message, value = nil)
    if message != nil && !message.empty?
      value = message if value == nil
      "<font color=red>#{value}</font>"
    else
      "#{value}" if value != nil
    end
  end
  
end

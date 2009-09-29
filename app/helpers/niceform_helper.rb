module NiceformHelper
  include UserinfoHelper
  
  def niceform_text_field(options, option, text_field_options = {})
    str_class = "textinput"
    str_class << " #{text_field_options[:class]}" if text_field_options[:class] != nil
    text_field_options[:class] = str_class
    text_field_options[:id] = "#{options}_#{option}"
    text_field_options[:style] = "width: 300px;" unless text_field_options[:style]
    
    field = text_field(options, option, text_field_options)
    niceform_field(field, text_field_options)
  end
  
  def niceform_passwd_field(id, options, option, passwd_field_options = {})
    str_class = "textinput"
    str_class << " #{passwd_field_options[:class]}" if passwd_field_options[:class] != nil
    passwd_field_options[:class] = str_class
    passwd_field_options[:id] = id
    passwd_field_options[:style] = "width: 300px;" unless passwd_field_options[:style]
    
    field = password_field(options, option, passwd_field_options)
    niceform_field(field, passwd_field_options)
  end
    
  def niceform_radio_botton_remind_day(id, cookie_info, range, range_text, field_option = {})
    niceform_radio_botton = "<div id=\"myRadio#{id}\" style=\"#{field_option[:style]}\" class=\""
    if remind_day_checked?(cookie_info, range)
      niceform_radio_botton << "radioAreaChecked"
    else
      niceform_radio_botton << "radioArea"
    end
    niceform_radio_botton << "\"></div>"
    niceform_radio_botton << "<input class=\"outtaHere\" "
    niceform_radio_botton << "name=\"user_info[remind_day]\" "
    niceform_radio_botton << "value=\"#{range}\" "
    niceform_radio_botton << "id=\"remind-day-#{id}\" "
    niceform_radio_botton << "type=\"radio\" "
    if remind_day_checked?(cookie_info, range)
      niceform_radio_botton << "checked=\"checked\" "
    end
    niceform_radio_botton << ">"
    niceform_radio_botton << "<span class=\"form-text\"><label for=\"remind-day-#{id}\" "
    if remind_day_checked?(cookie_info, range)
      niceform_radio_botton << "class=\"chosen\" "
    end
    niceform_radio_botton << ">"
    niceform_radio_botton << "#{range_text}</label></span><br>"
  end
  
  def niceform_radio_botton_remind_time(id, cookie_info, range, range_text, field_option = {})
    
    niceform_radio_botton = "<div id=\"myRadio#{id}\" style=\"#{field_option[:style]}\" class=\""
    if remind_time_checked?(cookie_info, range)
      niceform_radio_botton << "radioAreaChecked"
    else
      niceform_radio_botton << "radioArea"
    end
    niceform_radio_botton << "\"></div>"
    niceform_radio_botton << "<input class=\"outtaHere\" "
    niceform_radio_botton << "name=\"user_info[remind_time]\" "
    niceform_radio_botton << "value=\"#{range}\" "
    niceform_radio_botton << "id=\"remind-time-#{id}\" "
    niceform_radio_botton << "type=\"radio\" "
    if remind_time_checked?(cookie_info, range)
      niceform_radio_botton << "checked=\"checked\" "
    end
    niceform_radio_botton << ">"
    niceform_radio_botton << "<span class=\"form-text\"><label for=\"remind-time-#{id}\" "
    if remind_time_checked?(cookie_info, range)
      niceform_radio_botton << "class=\"chosen\" "
    end
    niceform_radio_botton << ">"
    niceform_radio_botton << "#{range_text}</label></span><br>"
  end
  
  def niceform_checkbox(id, cookie_info, text, div_option = {}, checkbox_option = {})
    niceform_checkbox = "<div id=\"myCheckbox#{id}\" style=\"#{div_option[:style]}\" class=\""
    if checked?(cookie_info, "true", "-1")
      niceform_checkbox << "checkboxAreaChecked"
    else
      niceform_checkbox << "checkboxArea"
    end
    niceform_checkbox << "\"></div>"
    niceform_checkbox << "<input class=\"outtaHere\" "
    niceform_checkbox << "name=\"#{checkbox_option[:params]}[#{checkbox_option[:param]}]\" "
    niceform_checkbox << "value=\"#{cookie_info}\" "
    niceform_checkbox << "id=\"#{checkbox_option[:id]}\" "
    niceform_checkbox << "type=\"checkbox\" "
    if checked?(cookie_info, "true", "-1")
      niceform_checkbox << "checked=\"checked\" "
    end
    niceform_checkbox << "/>"
    niceform_checkbox << "<span class=\"form-text\"><label for=\"#{checkbox_option[:id]}\" "
    if checked?(cookie_info, "true", "-1")
      niceform_checkbox << "style=\"font-size:1.2em; font-weight:bold\" "
    end
    niceform_checkbox << ">"
    niceform_checkbox << "#{text}</label></span><br>"
  end

  private
  def niceform_field(field, text_field_options = {})
    niceform_field = "<img class=\"inputCorner\" src=\"/images/niceforms/input_left.gif\">"
    niceform_field << field
    niceform_field << "<img class=\"inputCorner\" src=\"/images/niceforms/input_right.gif\">"  
  end
  
end
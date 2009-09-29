# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include DateFormatHelper
  
  def select_minute(datetime, options = {})
    minute_options = []

    0.step(59, options[:minute_step] || 1) do |minute|
      minute_options << ((datetime && (datetime.kind_of?(Fixnum) ? datetime : datetime.min) == minute) ?
        %(<option value="#{leading_zero_on_single_digits(minute)}" selected="selected">#{leading_zero_on_single_digits(minute)}</option>) :
        %(<option value="#{leading_zero_on_single_digits(minute)}">#{leading_zero_on_single_digits(minute)}</option>)
      )
    end

    select_html(options[:field_name] || 'minute', minute_options, options)
  end
        
  def select_hour(datetime, options = {})
    hour_options = []

    0.upto(23) do |hour|
      hour_options << ((datetime && (datetime.kind_of?(Fixnum) ? datetime : datetime.hour) == hour) ?
        %(<option value="#{leading_zero_on_single_digits(hour)}" selected="selected">#{leading_zero_on_single_digits(hour)}</option>) :
        %(<option value="#{leading_zero_on_single_digits(hour)}">#{leading_zero_on_single_digits(hour)}</option>)
      )
    end

    select_html(options[:field_name] || 'hour', hour_options, options)
  end
        
   def select_day(date, options = {})
    day_options = []

    1.upto(31) do |day|
      day_options << ((date && (date.kind_of?(Fixnum) ? date : date.day) == day) ?
        %(<option value="#{day}" selected="selected">#{day}</option>) :
        %(<option value="#{day}">#{day}</option>)
      )
    end

    select_html(options[:field_name] || 'day', day_options, options)
  end
        
  def select_month(date, options = {})
    month_options = []
    month_names = options[:use_short_month] ? Date::ABBR_MONTHNAMES : Date::MONTHNAMES

    1.upto(12) do |month_number|
      month_name = if options[:use_month_numbers]
        month_number
      elsif options[:add_month_numbers]
        month_number.to_s + ' - ' + month_names[month_number]
      else
        month_names[month_number]
      end

      month_options << ((date && (date.kind_of?(Fixnum) ? date : date.month) == month_number) ?
        %(<option value="#{month_number}" selected="selected">#{month_name}</option>) :
        %(<option value="#{month_number}">#{month_name}</option>)
      )
    end

    select_html(options[:field_name] || 'month', month_options, options)
  end
        
  def select_year(date, options = {})
    year_options = []
    y = date ? (date.kind_of?(Fixnum) ? (y = (date == 0) ? Date.today.year : date) : date.year) : Date.today.year

    start_year, end_year = (options[:start_year] || y-5), (options[:end_year] || y+5)
    step_val = start_year < end_year ? 1 : -1

    start_year.step(end_year, step_val) do |year|
      year_options << ((date && (date.kind_of?(Fixnum) ? date : date.year) == year) ?
        %(<option value="#{year}" selected="selected">#{year}</option>) :
        %(<option value="#{year}">#{year}</option>)
      )
    end

    select_html(options[:field_name] || 'year', year_options, options)
  end
        
  def select_html(type, options, selectoptions = {})
    select_html  = %(<select id="#{selectoptions[:id]}" class="#{selectoptions[:style_class]}" style="#{selectoptions[:style]}" name="#{selectoptions[:prefix] || "date"})
    select_html << "[#{type}]" unless selectoptions[:discard_type]
    select_html << %(")
    select_html << %( disabled="disabled") if selectoptions[:disabled]
    select_html << %(　)
    select_html << %( tmt:dtstart="true") if selectoptions["tmt:dtstart"]
    select_html << %(　)
    select_html << %( tmt:message="#{selectoptions["tmt:message"]}") if selectoptions["tmt:message"]
    select_html << %(>)
    select_html << %(<option value=""></option>) if selectoptions[:include_blank]
    select_html << options.to_s
    select_html << "</select>"
  end
  
  def template_error_messages_for (object_name, options = {})
    template_error_messages(object_name, 'error_messages_for', options)
  end
  
  def template_error_messages_for_mobile (object_name, options = {})
    template_error_messages(object_name, 'error_messages_for_mobile', options)
  end
  
  def date_parse(strDate)
    date = DateTime::strptime(strDate, "%Y-%m-%d %H:%M:%S")
  end
  
  def mobile_privacy_link
    link_to 'プライバシーポリシー', :controller=>'mobile', :action => 'privacy'
  end
  
  def mobile_terms_link
    link_to '利用規約', :controller=>'mobile', :action => 'terms'
  end
  
  private
  def template_error_messages (object_name, template_name, options = {})
    options = options.symbolize_keys
    object = instance_variable_get("@#{object_name}")
    if object != nil && !object.errors.empty?
      render :partial=> 'common/#{template_name}',
        :locals=>{:messages=>object.errors.full_messages, :object=>object}
    end
  end
end

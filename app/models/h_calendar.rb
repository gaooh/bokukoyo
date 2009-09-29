require 'erb'
require 'xmlrpc/client'
require 'uri'

class HCalendar < ActiveForm
  
  attr_accessor :fromurl, :update_date, :status, :summary, :dtstart, :dtstamp, :dtend, :location, :description, :url, :uid, :categories
  validates_presence_of :summary, :dtstart, :dtend, :message => "必須入力です。"
  validates_length_of :summary, :maximum=>256, :message => "イベントタイトルは256文字以内で入力してください。"
  validates_length_of :url, :maximum=>256, :message => "URLは256文字以内で入力してください。"
  validates_format_of :url, :with => /^https?:\/\/[^<>]+$/, :if => proc{|hcalendar| !hcalendar.url.blank? }, :message => "URLはhttp://もしくはhttps://で始まる半角英数字のみ登録可能です。"
  validates_length_of :location, :description, :categories, :maximum=>1024, :message => "最大半角1024文字以内で入力してください"
  
  def validate
    timecheck = true
    
    unless @dtstart.valid?
      @dtstart.errors.each { |error| errors.add( error[0], error[1]) }
      timecheck = false
    end
    
    unless @dtend.valid?
      @dtend.errors.each { |error| errors.add( error[0], error[1]) }
      timecheck = false
    end
    
    if timecheck
      if @dtstart.time.nil?
        errors.add(:dtstart, "開始時刻のフォーマットに問題があります。")
      elsif @dtend.time.nil?
        errors.add(:dtend, "終了時刻のフォーマットに問題があります。")
      elsif @dtstart.time < Time.now 
        errors.add(:dtstart, "開始時刻が過去のイベントは登録できません。")
      elsif @dtstart.time > @dtend.time
        errors.add(:dtend, "開始日付は終了時刻より前でなければなりません。")
      end
    end
  end
  
  def summary=(value)
    @summary = StringUtil.sanitize(value)
  end

  def location=(value)
    @location = StringUtil.sanitize(value)
  end
  
  def description=(value)
    @description = StringUtil.sanitize(value)
  end

  def categories=(values)
    senitizeValue = Array.new
    values.each { |value|
      senitizeValue << StringUtil.sanitize(value)
    }
    @categories = senitizeValue
  end
  
  def dtstart=(value)
    @dtstart = Dt.new.from_type("dtstart", value)
  end
  
  def dtend=(value)
    @dtend = Dt.new.from_type("dtend", value)
  end
  
  def update_date=(value)
    @update_date = Dt.new.from_type("update_date", value)
  end
  
  def daytime2dtstart(day, time)
    @dtstart = Dt.new.from_daytime("dtstart", day, time)
  end
  
  def daytime2dtend(day, time)
   @dtend = Dt.new.from_daytime("dtend", day, time)
  end
  
  def to_html
    
    body = HCalenderTemplate.new.to_html(self)
    filename = Util.random_string(32) + Time.now.strftime("%Y%m%d%H%M%S") + ".html"
    filepath = APP_CONFIG[:storage_path] + filename
    
    html = File.open(filepath,'w')
    html.puts body
    html.close
    
    return filename
  end
  
  def ping(filename)
    name = APP_CONFIG[:ping_name]
    url  = APP_CONFIG[:ping_from_url] + filename

    uri = URI.parse(APP_CONFIG[:ping_url])
    connection = XMLRPC::Client.new(uri.host, uri.path, uri.port)
    result =  connection.call("weblogUpdates.ping", name, url)
  end

  def self.marge_events(events)
    hCalendars = Array.new
    
    page= 0
    while true
      mfpsInfoList = ApiMfps.request({:page => page})
      
      mfpsInfoList.each { |mfpsInfo|
        events.each { |event|
          if event.html == mfpsInfo.fromhtml
            hCalendars << mfpsInfo
            break
          end
        }
      }
      break if hCalendars.size == events.size || mfpsInfoList == nil || mfpsInfoList.size == 0
      page+=1
    end
    
    hCalendars.reverse!{|a, b| a.update_date.time <=> b.update_date.time}
    return hCalendars
  end
  
  def fromhtml
    fromhtmls = @fromurl.split('/')
    fromhtml = fromhtmls[fromhtmls.length-1]
    return fromhtml
  end

  def fromhtmlname
    fromhtmls = self.fromurl.split('/')
    fromhtml = fromhtmls[fromhtmls.length-1]
    return fromhtml.split('.')[0] 
  end
  
  def str_categories
    if categories != nil
      str_categories = ""
      categories.each_with_index { |category, index|
        str_categories << category
        if index < categories.length-1
          str_categories << ','
        end
      }
      return str_categories
    end
  end
  
  public
  def to_s()
 	"[ #{@fromurl}, #{@url}, #{@description}, #{@location}, #{@status}, #{@summary}, #{@dtstart}, #{@dtstamp}, #{@dtend}, #{@uid}, #{@categories} ]"
  end
  
end

class HCalenderTemplate 
  extend ERB::DefMethod
  def_erb_method('to_html(hCalendar)', "#{RAILS_ROOT}/lib/microformats.rhtml")
end
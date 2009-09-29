#
# Dt 
#  日付を扱うクラス
#
# Author::    asami@drecom.co.jp
# Copyright:: Copyright(C) 2006 Drecom Co., Ltd. All Rights Reserved.

class Dt < ActiveForm 
  attr_accessor :name, :year, :month, :day, :hour, :minute
  validates_presence_of :year, :month, :day, :hour, :minute => "必須入力です。"
    
  def from_type(name, value)
    @name = name
    if value.kind_of?(Hash)
      return create_by_params(value)
    elsif value.kind_of?(String)
      return create_by_mfps(value)
    elsif value.kind_of?(Time)
      return create_by_time(value)
    end
  end
  
  def from_daytime(name, day, time)
    @name = name
    @year = day[0,4]
    @month = day[4,2]
    @day = day[6,2]
    
    @hour = time[0,2]
    @minute = time[2,2]
    return self
  end
     
  def validate
    day = self.str_day
    time = self.str_time
    
    return_flag = false
    if day.nil? || day !~ /\d{8}/
      errors.add("#{name}_day", "20070101など数字8桁の形式で入力してください。")
      return_flag = true
    end
    
    if time.nil? || (time =~/\d{4}/).nil?
      errors.add("#{name}_time", "1212など数字4桁の形式で入力してください。")
      return_flag = true
    end
    
    return if return_flag
    
    if @month.to_i < 0 || @month.to_i > 12 || @day.to_i < 0 || @day.to_i > 31
      errors.add("#{name}_day", "日付として正しい値を入力してください。")
    end
    if @hour.to_i < 0 || @hour.to_i > 23 || @minute.to_i < 0 || @minute.to_i > 59
      errors.add("#{name}_time", "時刻として正しい値を入力してください。")
    end
  end
  
  def time
    return Time::local(@year, @month, @day, @hour, @minute)
  end
  
  def utc_time
    return Time::local(@year, @month, @day, @hour, @minute).getutc
  end
  
  def str_day
    return "#{@year}#{@month}#{@day}"
  end
  
  def str_time
    return "#{sprintf("%02d", @hour)}#{sprintf("%02d", @minute)}"
  end
  
  def iso8601
    iso8601 = ""
    iso8601 << "#{@year}"
    iso8601 << sprintf("%02d", @month.to_i) 
    iso8601 << sprintf("%02d", @day.to_i) 
    iso8601 << "T"
    iso8601 << "#{@hour}"
    iso8601 << "#{@minute}"
    iso8601 << "+0900"
    return iso8601
  end
  
  private 
  
  def create_by_params(params)
    @year = params[:year]
    @month = sprintf("%02d", params[:month])
    @day = sprintf("%02d", params[:day])
    @hour = params[:hour]
    @minute = params[:minute]
    return self
  end
  
  def create_by_mfps(value)
    date = Util.str2date(value)
    @year = date.year
    @month = sprintf("%02d", date.month)
    @day = sprintf("%02d", date.day)
    @hour = date.hour
    @minute = date.min
    return self
  end
  
  def create_by_time(value)
     @year = value.year
     @month = sprintf("%02d", value.month)
     @day = sprintf("%02d", value.day)
     @hour = value.hour
     @minute = value.min
     return self
  end
  
end
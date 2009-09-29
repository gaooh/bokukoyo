require 'parsedate'
require "jcode"
require "nkf"

class Util
  RAND_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz"

 def self.random_string(len)
   rand_max = RAND_CHARS.size
   ret = ""
   len.times{ ret << RAND_CHARS[rand(rand_max)] }
   ret
 end
 
 def self.iso2time(value)
   return nil if value == nil || value == ''
   
   begin
     date_array = ParseDate::parsedate(value)
     date = Time::local(*date_array[0..-4])
     return date
   rescue
      return nil
   end
 end

 def self.str2date(value)
   return nil if value == nil || value == ''
   
   begin
     date = DateTime::strptime(value, "%Y-%m-%d %H:%M:%S")
     return date
   rescue
     return nil
   end
 end
  
end
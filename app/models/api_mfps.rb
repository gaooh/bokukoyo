
require 'net/http'
require 'rexml/document'
Net::HTTP.version_1_2
require 'parsedate'

class ApiMfps
   
   #=== request
   # 検索処理をする。
   #
   # Param::  request_params(hash) リクエストパラメータ
   # Return:: Array(hCalendarInfo) 結果が取得できなかった場合はnil
   public
   def self.request(request_params = {})
     #return request_test(request_params)
     debug("ApiMfps Request start --")

     doc = connection(request_params)
     result = anallize(doc)

     return result
   end

   #=== specific_request
   # 特定の１情報を取得するリクエスト　過去情報は対象としない
   #
   # Param::  html(string) 発信元
   # Return:: hCalendar 結果が取得できなかった場合はnil
   public
   def self.specific_request(html)
     #return request_test({:page => 0})[0]
     debug("ApiMfps Request start --")

     doc = connection({:page => 0, :max=> 1, :html=> html})
     result = anallize(doc)
     if result != nil && !result.empty?
        return result[0]
      else
        return nil
      end
   end
   
   #=== specific_request_all
   # 特定の１情報を取得するリクエスト 過去情報も対象とする
   #
   # Param::  html(string) 発信元
   # Return:: hCalendar 結果が取得できなかった場合はnil
   public
   def self.specific_request_all(html)
     #return request_test({:page => 0})[0]
     debug("ApiMfps Request start --")

     doc = connection({:page => 0, :max=> 1, :html=> html, :type_all=> true})
     result = anallize(doc)
     if result != nil && !result.empty?
       return result[0]
     else
       return nil
     end
   end
   
   #=== connection
   # MFPS APIのコネクションポイントと接続をし、レスポンスを取得
   #
   # Param::  request_params[:page] (string) ページ番号
   # Param::  request_params[:max] (string) 取得最大数
   # Param::  request_params[:category] (string) カテゴリ
   # Param::  request_params[:html] (string) 発信元
   # Param::  request_params[:type_all] (boolean) 対象を全体にするか
   # Retrun:: REXML::Document 解析用XML
   private
   def self.connection(request_params = {})
     
     fromurl = ""
     fromurl << APP_CONFIG[:hcalendar_url]
     fromurl << request_params[:html] if request_params[:html] != nil
     
     query = ""
     query << APP_CONFIG[:request]
     query << "?fromurl=#{fromurl}"
     query << "&dtstart=" + request_params[:dtstart] if request_params[:dtstart] != nil
     query << "&category=" + URI.encode(request_params[:category]) if request_params[:category] != nil
     query << "&max=" + request_params[:max].to_s if request_params[:max] != nil
     query << "&pagenum=" + request_params[:page].to_s if request_params[:page] != nil
     query << "&type=all" if request_params[:type_all]
     
     debug("[Query]:" + query)

     begin
       Net::HTTP.start(APP_CONFIG[:mfps_host], APP_CONFIG[:mfps_port]) { |http|
         response = http.get(query)
         doc = REXML::Document.new response.body
     
         return doc
       }
     rescue Exception => e
       error("can't connection to MFPS:#{e}")
       # TODO 例外処理
     end  
     
     return nil
   end

   #=== anallize
   # レスポンスを解析しオブジェクトにする
   # Param::  doc(string)
   # Return:: hCalendarInfo 結果が取得できなかった場合はnil
   private
   def self.anallize(doc)
     results = Array.new
     
     REXML::XPath.each( doc, "//hCalendar") { |element|

       info = HCalendar.new
       info.fromurl = element.elements["fromurl"].text
       info.url = element.elements["url"].text
       info.update_date = element.elements["updateDate"].text
       info.description = element.elements["description"].text
       info.location = element.elements["location"].text
       info.status = element.elements["status"].text
       info.summary = element.elements["summary"].text
       info.dtstart = element.elements["dtstart"].text
       info.dtstamp = element.elements["dtstamp"].text
       info.dtend = element.elements["dtend"].text
       info.uid = element.elements["uid"].text
       
       categories_element = element.elements["categories"]
       categories = Array.new
       categories_element.each_element { | category |
         if category.name == "category"
           categories << category.text
         end
       }
       info.categories = categories
       
       debug(" -> [Result]:#{info.to_s}")
       results << info
     }

     debug(" -> [result size]:#{results.length}")
     return results
   end

   def self.request_test(params = {})
     if params[:page] == 0
       file = open("/Users/ebisen/ruby/bokukoyo/test/hCalendar.xml")
       doc = REXML::Document.new file.read
       file.close
       result = anallize(doc)
       return result
     else
       return Array.new
     end
   end
   
   def self.debug(message)
     ApplicationController.logger.debug("[MFPS - API]: #{message}")
   end

   def self.info(message)
     ApplicationController.logger.info("[MFPS - API]: #{message}")
   end
    
   def self.error(message)
     ApplicationController.logger.error("[MFPS - API]: #{message}")
   end
    
end
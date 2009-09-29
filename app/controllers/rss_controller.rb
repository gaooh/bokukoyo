require 'rss/maker'

class RssController < ApplicationController
  after_filter :to_rss

  def publish
    
   events = Event.find_public_evnet(10) # TODO 定義値外だし
   hCalendars = HCalendar.marge_events(events)
     
   rss = RSS::Maker.make("1.0") do |maker|
     maker.channel.about = url_for(:controller => 'rss', :action => 'publish')
     maker.channel.title = APP_CONFIG[:domain]
     maker.channel.link = url_for(:controller => 'post', :action => 'top')
     maker.channel.description = "ぼくこよ - 僕のカレンダーに挿した素敵な招待状"
     maker.channel.copyright = "Copyright(c) 2007 Drecom Co.,Ltd.All Rights Reserved."

     hCalendars.each_with_index do |hCalendar,index|
       item = maker.items.new_item
       item.title = hCalendar.summary
       item.description = hCalendar.description
       item.date = events[index].post_at
       if hCalendar.url != nil
         item.link = hCalendar.url 
       else
         item.link = ''
       end
     end

     maker.items.do_sort = true
     maker.items.max_size = 10
   end
   
   render :text => rss.to_s, :layout => false
   
   end
end

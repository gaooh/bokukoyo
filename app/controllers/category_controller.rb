class CategoryController < ApplicationController
  mobile_filter
  after_filter :defalut_charset
  helper :post
  helper :niceform
  helper :mobile
  
  layout :basic_layout
  
  CATEGORY_VIEW_COUNT = 5
  CATEGORY_GET_COUNT = CATEGORY_VIEW_COUNT+1
  
  def list
    setup_userinfo
    
    @category_name = params[:id]
    if params[:pagenum].nil?
      @pagenum = 0
    else
      @pagenum = params[:pagenum].to_i
    end
    helper_list(@pagenum, @category_name)
  end
  
  #=== next_load
  # ページ送り。RJS  
  def next_load
    @category_name = params[:id]
    @pagenum = params[:pagenum].to_i
    helper_list(@pagenum, @category_name)
  end
  
  private
  def helper_list(page, category_name)
    @hCalendars = Array.new
    offset = page * CATEGORY_VIEW_COUNT
    mfpspage = 0
    count = 0
    while true
      mfpsInfoList = ApiMfps.request({:page => mfpspage, :max => 20, :category => category_name})
      
      mfpsInfoList.each { |mfpsInfo|
        event = Event.find_by_html(mfpsInfo.fromhtml)
        if !event.nil? && event.public_flag
          count += 1
          @hCalendars << mfpsInfo if count > offset
          break if @hCalendars.size >= CATEGORY_GET_COUNT
        end
      }
      break if mfpsInfoList.nil? || mfpsInfoList.empty?
      mfpspage+=1
    end
    
    @has_next = false
    if @hCalendars.size == CATEGORY_GET_COUNT
      @hCalendars.delete_at(CATEGORY_GET_COUNT)
      @has_next = true
    end
  end
end

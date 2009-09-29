class IcalController < ApplicationController
  after_filter :to_calendar

  def generate
    @hCalendar = ApiMfps.specific_request("#{params[:id]}.html") # 『.』が入るとうまくいかない
  end
end

#
# table events 
#  auth_email_id, :integer, :null => false
#  html, :string, :limit => 128, :null=>false
#  public_flag, :boolean, :defaut => true, :null => false
#  post_at, :datetime, :null => false
#  delivery_at, :datetime, :null => false
#  delivered_flag, :boolean, :null => false # 配達後にonになる
#
# Author::    asami@drecom.co.jp
# Copyright:: Copyright(C) 2006 Drecom Co., Ltd. All Rights Reserved.

class Event < ActiveRecord::Base
  validates_presence_of :auth_email_id, :html, :public_flag, :post_at, :delivery_at, :delivered_flag, :on => :create
  validates_length_of :html, :maximum=>128
  
  #=== find_by_public
  # 公開されている、かつまだ終了していないイベントを登録順に表示
  def self.find_public_evnet(limit, offset=0)
    find(:all, :conditions=> ["public_flag = true"], :order => "post_at DESC", :limit => limit, :offset=> offset)
  end  
  
  #=== find_by_public_event_count
  # 公開済みイベント総数
  def self.find_by_public_event_count
    find(:first , :select => "count(*) as count", :conditions=> ["public_flag = true"])
  end
  
  #=== find_by_delivery
  # 配達対象のレコードを取得
  def self.find_by_delivery
    find(:all, :conditions=> ["delivery_at <= ? and delivered_flag = false", Time.now])
  end
  
end

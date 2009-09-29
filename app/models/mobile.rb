#
# create_table :mobiles do |t|
#    t.column :ident, :string, :limit => 128, :null => false
#    t.column :auth_email_id, :integer, :null => false
#    t.column :nickname, :string, :limit => 32, :null=>false
#    t.column :remind_day, :integer, :null => false
#    t.column :remind_time, :string, :null => false
#    t.column :created_at, :datetime
# end
#
# Author::    asami@drecom.co.jp
# Copyright:: Copyright(C) 2006 Drecom Co., Ltd. All Rights Reserved.

class Mobile < ActiveRecord::Base
  validates_presence_of :ident, :auth_email_id, :nickname, :remind_day, :remind_time, :created_at
  validates_length_of :ident, :maximum=>128
  validates_length_of :nickname, :maximum=>32
  
  def str_remind_day(value)
    if value == 'previous'
      self.remind_day = -1
    else
      self.remind_day = 0
    end
  end
  
end

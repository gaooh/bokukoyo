class CreateMobileInfo < ActiveRecord::Migration
  
  def self.up
   create_table :mobiles do |t|
      t.column :ident, :string, :limit => 128, :null => false
      t.column :auth_email_id, :integer, :null => false
      t.column :nickname, :string, :limit => 32, :null=>false
      t.column :remaind_day, :integer, :null => false
      t.column :remind_time, :string, :null => false
      t.column :create_at, :datetime
   end
  end

  def self.down
     drop_table :mobiles
  end
end

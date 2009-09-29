class ChangeSpell < ActiveRecord::Migration
  def self.up
    rename_column(:mobiles, :remaind_day, :remind_day) 
  end

  def self.down
    rename_column(:mobiles, :remind_day, :remaind_day)
  end
end

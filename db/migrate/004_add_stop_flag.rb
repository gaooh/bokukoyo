class AddStopFlag < ActiveRecord::Migration
  def self.up
     add_column(:events, :stop_flag, :boolean, :default=> false)
  end

  def self.down
    remove_column(:events, :stop_flag)
  end
end

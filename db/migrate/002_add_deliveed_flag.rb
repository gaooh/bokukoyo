class AddDeliveedFlag < ActiveRecord::Migration
  def self.up
    add_column(:events, :delivered_flag, :boolean, :default=> false)
  end

  def self.down
    remove_column(:events, :delivered_flag)
  end
end

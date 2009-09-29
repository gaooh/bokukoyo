class ChangeStopFlag < ActiveRecord::Migration
  def self.up
    add_column(:auth_emails, :stop_flag, :boolean, :default=> false)
    remove_column(:events, :stop_flag)
  end

  def self.down
    add_column(:events, :stop_flag, :boolean, :default=> false)
    remove_column(:auth_emails, :stop_flag)
  end
end

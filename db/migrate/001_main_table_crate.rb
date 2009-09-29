class MainTableCrate < ActiveRecord::Migration
  def self.up
    create_table :auth_emails do |t|
      t.column :mail_address, :string, :limit => 256, :null => false
      t.column :bk_code, :string, :limit => 32, :null=>true
      t.column :invite_code, :string, :limit => 32, :null=>false
      t.column :auth_flag, :boolean, :defalut => false, :null => false
      t.column :created_at, :datetime
    end
    
    create_table :events do |t|
      t.column :auth_email_id, :integer, :null => false
      t.column :html, :string, :limit => 128, :null=>false
      t.column :public_flag, :boolean, :defaut => true, :null => false
      t.column :post_at, :datetime, :null => false
      t.column :delivery_at, :datetime, :null => true
    end
  end

  def self.down
    drop_table :auth_emails
    drop_table :events
  end
end

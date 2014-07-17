class CreateDemoSettings < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :demo_settings do |t|
      t.integer :account_id, :limit => 8
      t.datetime :start_at
      t.datetime :end_at
      t.string   :remarks
      t.timestamps
    end
  end

  def self.down
    drop_table :demo_settings
  end
end

class CreateDemoMessages < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :demo_messages do |t|
      t.string :organization
      t.text :message
      t.timestamps
    end
  end

  def self.down
    drop_table :demo_messages
  end
end

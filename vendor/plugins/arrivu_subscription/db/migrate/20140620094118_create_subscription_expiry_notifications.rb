class CreateSubscriptionExpiryNotifications < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :subscription_expiry_notifications do |t|
      t.belongs_to :subscription,:limit => 8
      t.string :workflow_state, :default => 'new'
      t.integer :notify_day
      t.date :expire_on
      t.timestamps
    end
  end

  def self.down
    drop_table :subscription_expiry_notifications
  end
end

class SubscriptionIdAdd < ActiveRecord::Migration
  tag :predeploy
  def self.up
    remove_column :subscription_messages, :organization
    add_column :subscription_messages, :subscription_id, :integer, :limit => 8
  end

  def self.down
  end
end

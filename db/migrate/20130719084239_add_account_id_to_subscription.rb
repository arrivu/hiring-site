class AddAccountIdToSubscription < ActiveRecord::Migration
  tag :predeploy
  def self.up
    remove_column :subscription_account_settings, :account_id
    add_column :subscriptions, :account_id, :integer, :limit => 8
    add_column :subscription_account_settings, :subscription_id, :integer, :limit => 8
  end

  def self.down
  end
end

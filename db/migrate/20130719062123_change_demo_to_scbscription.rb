class ChangeDemoToScbscription < ActiveRecord::Migration
  tag :predeploy
  def self.up
    rename_table :demos, :subscriptions
    rename_table :demo_account_settings, :subscription_account_settings
    rename_table :demo_messages, :subscription_messages
    rename_table :demo_configs, :subscription_configs
  end

  def self.down
  end
end

class ChangeDemoSettingsTableName < ActiveRecord::Migration
  tag :predeploy
  def self.up
    rename_table :demo_settings, :demo_account_settings
  end

  def self.down
  end
end

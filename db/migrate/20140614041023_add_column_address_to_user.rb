class AddColumnAddressToUser < ActiveRecord::Migration
  tag :predeploy

  def self.up
    add_column :users, :address, :text
  end

  def self.down
    remove_column :users, :address
  end
end

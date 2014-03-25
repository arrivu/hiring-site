class AddPersonalDetailsToUser < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :users, :middle_name, :text
    add_column :users, :last_name, :text
    add_column :users, :state, :text
    add_column :users, :city, :text
    add_column :users, :zip_code, :text


  end

  def self.down
    remove_column :users, :middle_name
    remove_column :users, :last_name
    remove_column :users, :state
    remove_column :users, :city
    remove_column :users, :zip_code


  end
end

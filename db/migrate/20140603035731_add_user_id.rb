class AddUserId < ActiveRecord::Migration
  tag :predeploy

  def self.up
    add_column :imageproctorings, :user_id, :integer, :limit => 8
  end

  def self.down
    remove_column :imageproctorings, :user_id
  end
end

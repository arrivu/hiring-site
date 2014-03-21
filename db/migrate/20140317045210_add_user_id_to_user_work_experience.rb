class AddUserIdToUserWorkExperience < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :user_work_experiences, :user_id, :integer, :limit => 8
  end

  def self.down
    remove_column :user_work_experiences, :user_id
  end
end

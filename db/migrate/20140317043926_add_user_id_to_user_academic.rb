class AddUserIdToUserAcademic < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :user_academics, :user_id, :integer, :limit => 8
  end

  def self.down
    remove_column :user_academics, :user_id
  end

end

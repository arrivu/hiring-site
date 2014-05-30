class GuizGroupToTagId < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :quiz_groups, :tag_id, :integer, :limit => 8
  end

  def self.down
    remove_column :quiz_groups, :tag_id, :integer
  end
end

class AddCourseColumnToFeatureWish < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :feature_wishes, :course, :text
  end

  def self.down
    remove_column :feature_wishes, :course
  end
end

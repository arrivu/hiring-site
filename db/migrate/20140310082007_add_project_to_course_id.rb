class AddProjectToCourseId < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :candidate_details, :course_id, :integer, :limit => 8
  end

  def self.down
    remove_column :candidate_details, :course_id
  end
end

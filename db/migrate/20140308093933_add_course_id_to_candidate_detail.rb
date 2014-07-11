class AddCourseIdToCandidateDetail < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :candidate_details, :project_id, :integer, :limit => 8
  end

  def self.down
    remove_column :candidate_details, :project_id
  end
end

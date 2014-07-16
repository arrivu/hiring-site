class AddSubmissionIdToImageproctoring < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :imageproctorings, :submission_id, :integer, :limit => 8
  end

  def self.down
    remove_column :imageproctorings, :submission_id
  end
end

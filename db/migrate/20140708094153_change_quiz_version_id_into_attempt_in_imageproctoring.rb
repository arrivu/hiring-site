class ChangeQuizVersionIdIntoAttemptInImageproctoring < ActiveRecord::Migration
  tag :predeploy
  def self.up
    remove_column :imageproctorings, :quiz_version_id

  end

  def self.down
    add_column :imageproctorings, :quiz_version_id, :integer
  end
end

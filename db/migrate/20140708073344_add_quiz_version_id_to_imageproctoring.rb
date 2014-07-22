class AddQuizVersionIdToImageproctoring < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :imageproctorings, :quiz_version_id, :integer, :limit => 8
  end

  def self.down
    add_column :imageproctorings, :quiz_version_id, :integer, :limit => 8
  end
end

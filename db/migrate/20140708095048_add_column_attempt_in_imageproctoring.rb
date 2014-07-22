class AddColumnAttemptInImageproctoring < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :imageproctorings, :attempt, :integer, :limit => 8
  end

  def self.down
    add_column :imageproctorings, :attempt, :integer, :limit => 8
  end
end

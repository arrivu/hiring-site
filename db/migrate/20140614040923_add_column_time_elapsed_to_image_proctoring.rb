class AddColumnTimeElapsedToImageProctoring < ActiveRecord::Migration
  tag :predeploy

  def self.up
    add_column :imageproctorings, :time_elapsed, :text
  end

  def self.down
    remove_column :imageproctorings, :time_elapsed
  end
end

class AddColumnToImageProctoring < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :imageproctorings, :attachment_id, :integer, :limit => 8
  end
  def self.down
    remove_column :imageproctorings, :attachment_id
  end
end

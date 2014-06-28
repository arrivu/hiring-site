class ChangeColumnTypeToBinaryInImageproctorings < ActiveRecord::Migration
  tag :predeploy
  def self.up
    change_column :imageproctorings, :imageData, :binary
  end

  def self.down
    change_column :imageproctorings, :imageData, :text
  end
end

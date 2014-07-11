class CreateImageproctorings < ActiveRecord::Migration
  tag :predeploy

  def self.up
    create_table :imageproctorings do |t|
      t.text :imageData
      t.timestamps
    end
  end

  def self.down
    drop_table :imageproctorings
  end
end

class AddQuizId < ActiveRecord::Migration
  tag :predeploy

  def self.up
    add_column :imageproctorings, :quiz_id, :integer, :limit => 8
  end

  def self.down
    remove_column :imageproctorings, :quiz_id
  end
end

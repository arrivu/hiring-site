class CreateCourseUniqueCodeAssociations < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :course_unique_code_associations do |t|
      t.integer :course_id, :limit => 8
      t.text :unique_access_code ,:unique => true
      t.timestamps
    end
  end

  def self.down
    drop_table :course_unique_code_associations
  end
end

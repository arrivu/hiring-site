class AddScectionIdToCourseUniqueCodeAssociation < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :course_unique_code_associations, :course_section_id , :integer, :limit => 8
  end

  def self.down
    remove_column :course_unique_code_associations, :course_section_id
  end
end

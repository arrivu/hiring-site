class QuizIdToCourseUniqueCodeAssociation < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :course_unique_code_associations, :quiz_id , :integer, :limit => 8
  end

  def self.down
    remove_column :course_unique_code_associations, :quiz_id
  end
end

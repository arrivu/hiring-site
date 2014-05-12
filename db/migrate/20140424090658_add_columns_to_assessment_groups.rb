class AddColumnsToAssessmentGroups < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :quiz_groups, :shuffle_questions, :boolean
  end

  def self.down
    remove_column :quiz_groups, :shuffle_questions
  end
end

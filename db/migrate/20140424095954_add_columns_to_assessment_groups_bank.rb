class AddColumnsToAssessmentGroupsBank < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :quiz_groups, :shuffle_question_bank, :boolean, :default => false
  end

  def self.down
    remove_column :quiz_groups, :shuffle_question_bank
  end
end

class ChangeColumnsShuffleQuestionBank < ActiveRecord::Migration
  tag :predeploy
  def self.up
    change_column :quiz_groups, :shuffle_question_bank, :boolean, :default => true
  end

  def self.down
    change_column :quiz_groups, :shuffle_question_bank, :boolean, :default => false
  end
end

class AddColumnShowCorrectAnswersToAssignmentOverrides < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :assignment_overrides, :show_correct_answers_at, :datetime
    add_column :assignment_overrides, :hide_correct_answers_at, :datetime
    add_column :assignment_overrides, :show_correct_answers_at_overridden, :boolean, :default => false
    add_column :assignment_overrides, :hide_correct_answers_at_overridden, :boolean, :default => false
  end

  def self.down
    remove_column :assignment_overrides, :show_correct_answers_at
    remove_column :assignment_overrides, :hide_correct_answers_at
    remove_column :assignment_overrides, :show_correct_answers_at_overridden
    remove_column :assignment_overrides, :hide_correct_answers_at_overridden
  end
end

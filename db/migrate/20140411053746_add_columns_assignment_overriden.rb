class AddColumnsAssignmentOverriden < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :assignment_overrides, :show_correct_answers_at_overridden, :boolean, :default => false
    add_column :assignment_overrides, :hide_correct_answers_at_overridden, :boolean, :default => false
  end

  def self.down
    remove_column :assignment_overrides, :show_correct_answers_at_overridden
    remove_column :assignment_overrides, :hide_correct_answers_at_overridden
  end
end

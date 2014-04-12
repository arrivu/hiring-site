class AddColumnsToAssignmentOverride < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :assignment_overrides, :show_correct_answers_at, :timestamp
    add_column :assignment_overrides, :hide_correct_answers_at, :timestamp
  end

  def self.down
    remove_column :assignment_overrides, :show_correct_answers_at
    remove_column :assignment_overrides, :hide_correct_answers_at
  end
end

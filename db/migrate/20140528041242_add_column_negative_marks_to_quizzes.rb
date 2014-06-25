class AddColumnNegativeMarksToQuizzes < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :quizzes, :allow_negative_marks, :boolean, :default => false
    add_column :quizzes, :negative_mark, :integer
  end

  def self.down
    remove_column :quizzes, :allow_negative_marks
    remove_column :quizzes, :negative_mark
  end
end

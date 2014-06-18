class ChangeColumnNegativeMarksToQuiz < ActiveRecord::Migration
  tag :predeploy
  def self.up
    change_column :quizzes, :negative_mark, :float
  end

  def self.down
    change_column :quizzes, :negative_mark, :integer
  end
end

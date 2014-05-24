class AddColumnsShowResultQuiz < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :quizzes, :show_result, :boolean, :default => false
    add_column :quizzes, :percentage_of_marks, :integer
  end

  def self.down
    remove_column :quizzes, :show_result
    remove_column :quizzes, :percentage_of_marks
  end
end

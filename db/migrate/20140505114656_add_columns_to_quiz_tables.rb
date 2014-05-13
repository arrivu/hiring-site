class AddColumnsToQuizTables < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :quizzes, :online_proctoring, :boolean, :default => false
    add_column :quizzes, :image_proctoring, :boolean, :default => false
    add_column :quizzes, :web_proctoring, :boolean, :default => false
    add_column :quizzes, :maximum_web_proctoring, :integer
    add_column :quizzes, :show_remaining_counts, :boolean, :default => false

  end

  def self.down
    remove_column :quizzes, :online_proctoring
    remove_column :quizzes, :image_proctoring
    remove_column :quizzes, :web_proctoring
    remove_column :quizzes, :maximum_web_proctoring
    remove_column :quizzes, :show_remaining_counts
  end
end

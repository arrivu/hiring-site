class AddColumnsToQuizMaxImgProctoringLimit < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :quizzes, :maximum_image_proctoring, :integer
  end

  def self.down
    remove_column :quizzes, :maximum_image_proctoring
  end
end

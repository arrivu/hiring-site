class AddColumnsCheckboxQuizSubmission < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :quiz_submissions, :allow_academic_detail, :boolean, :default => false
    add_column :quiz_submissions, :allow_employment_detail, :boolean, :default => false
    add_column :quiz_submissions, :allow_assessment_detail, :boolean, :default => false
    add_column :quiz_submissions, :allow_image_proctoring, :boolean, :default => false
  end

  def self.down
    remove_column :quiz_submissions, :allow_academic_detail
    remove_column :quiz_submissions, :allow_employment_detail
    remove_column :quiz_submissions, :allow_assessment_detail
    remove_column :quiz_submissions, :allow_image_proctoring
  end
end

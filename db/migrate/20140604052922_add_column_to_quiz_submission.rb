class AddColumnToQuizSubmission < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :quiz_submissions, :allow_personal_detail, :boolean, :default => false
  end

  def self.down
    remove_column :quiz_submissions, :allow_personal_detail
  end
end

class AddCandidateReportsToAddUserQuizAttachmentId < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :candidate_reports, :quiz_id, :integer, :limit => 8
    add_column :candidate_reports, :user_id, :integer, :limit => 8
    add_column :candidate_reports, :attachment_id, :integer, :limit => 8
  end

  def self.down
    remove_column :candidate_reports, :quiz_id
    remove_column :candidate_reports, :user_id
    remove_column :candidate_reports, :attachment_id
  end
end

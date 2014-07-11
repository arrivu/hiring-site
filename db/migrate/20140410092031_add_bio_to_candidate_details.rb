class AddBioToCandidateDetails < ActiveRecord::Migration
  tag :postdeploy
  def self.up
    add_column :candidate_details, :bio, :boolean
  end

  def self.down
    remove_column :candidate_details, :bio
  end
end

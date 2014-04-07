class AddColumnsProfilePictureToCandidatedetail < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :candidate_details, :profile_picture, :boolean
  end

  def self.down
    remove_column :candidate_details, :profile_picture
  end
end

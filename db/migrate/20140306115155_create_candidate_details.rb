class CreateCandidateDetails < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :candidate_details do |t|
      t.boolean :first_name
      t.boolean :middle_name
      t.boolean :last_name
      t.boolean :dob
      t.boolean :contact_number
      t.boolean :email_id
      t.boolean :address
      t.boolean :academics
      t.boolean :employment
      t.boolean :current_compensation
      t.boolean :expected_compensation
      t.timestamps
    end
  end

  def self.down
    drop_table :candidate_details
  end
end

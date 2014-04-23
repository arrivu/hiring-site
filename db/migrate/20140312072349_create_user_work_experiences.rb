class CreateUserWorkExperiences < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :user_work_experiences do |t|
      t.text :organization
      t.text :from_date
      t.text :end_date
      t.text :designation
      t.text :permanent
      t.text :reason_for_leaving
      t.integer :user_profile_id , :limit => 8
      t.timestamps
    end
  end

  def self.down
    drop_table :user_work_experiences
  end
end

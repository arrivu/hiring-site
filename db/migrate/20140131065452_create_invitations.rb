class CreateInvitations < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :invitations do |t|
      t.integer :pseudonym_id , :limit => 8
      t.integer :quiz_id  , :limit => 8
      t.text :email
      t.text :first_name
      t.text :last_name
      t.string :dob
      t.text :contact_number
      t.string :gender
      t.text :country
      t.text :uid_type
      t.text :uid
      t.text :access_code ,:unique => true
      t.string :workflow_status
      t.boolean :get_details
      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end

end

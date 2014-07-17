class CreateDemos < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :demos do |t|
      t.string :organization
      t.string :name
      t.string :title
      t.string :email
      t.string :phone
      t.string :organization_type
      t.string :organization_size
      t.string :current_lms
      t.timestamps
    end
  end

  def self.down
    drop_table :demos
  end
end

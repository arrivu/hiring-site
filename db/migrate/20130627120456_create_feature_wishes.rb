class CreateFeatureWishes < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :feature_wishes do |t|
      t.string :account_name
      t.string :user_name
      t.string :unique_id
      t.string :feature_clicked
      t.datetime :clicked_at
      t.boolean :submited_to_admin, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :feature_wishes
  end
end

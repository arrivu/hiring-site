class CreateDemoConfigs < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :demo_configs do |t|
      t.string :email
      t.string :redirect_url
      t.timestamps
    end
  end

  def self.down
    drop_table :demo_configs
  end
end

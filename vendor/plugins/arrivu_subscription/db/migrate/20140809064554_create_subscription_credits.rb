class CreateSubscriptionCredits < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :subscription_credits do |t|
      t.column :subscription_id, :integer, :null => false ,:limit => 8
      t.column :account_id, :integer, :null => false ,:limit => 8
      t.column :amount, :integer, :null => false

    end
  end

  def self.down
    drop_table :subscription_credits
  end
end

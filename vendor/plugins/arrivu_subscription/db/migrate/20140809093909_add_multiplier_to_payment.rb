class AddMultiplierToPayment < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :payments, :multiplier, :integer, :limit => 8
  end

  def self.down
    remove_column :payments, :multiplier
  end
end

class AddSubdomainToDemo < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :demos, :subdomain, :string
  end

  def self.down
  end
end

class CreateUserAcademics < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :user_academics do |t|
      t.text :degree
      t.text :discipline
      t.text :college
      t.text :university
      t.text :year_of_completion
      t.text :percentage
      t.timestamps
    end
  end

  def self.down
    drop_table :user_academics
  end
end

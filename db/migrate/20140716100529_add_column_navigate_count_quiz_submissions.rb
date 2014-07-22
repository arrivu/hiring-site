class AddColumnNavigateCountQuizSubmissions < ActiveRecord::Migration
  tag :postdeploy
  def self.up
    add_column :quiz_submissions, :navigate_count, :integer, :limit => 8
  end

  def self.down
    remove_column :quiz_submissions, :navigate_count
  end
end

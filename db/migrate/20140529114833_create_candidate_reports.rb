class CreateCandidateReports < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :candidate_reports do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :candidate_reports
  end
end

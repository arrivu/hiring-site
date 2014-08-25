class CreateUserAssessmentTransactions < ActiveRecord::Migration
  tag :predeploy

  def self.up
    create_table :user_assessment_transactions do |t|
      t.integer :user_id, :limit => 8, :null => false
      t.integer :context_id, :limit => 8, :null => false
      t.string  :context_type, :null => false
      t.integer :submission_id, :limit => 8, :null => false
      t.integer :quiz_id,:limit => 8, :null => false
      t.integer :transaction_amount,:limit => 8, :null => false
    end
  end

  def self.down
    drop_table :user_assessment_transactions
  end
end

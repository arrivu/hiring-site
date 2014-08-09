class CreateFeatureSets < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :feature_sets, :force => true do |t|
      t.integer :account_id, :null => false,:limit => 8
      t.string  :name
      t.integer :permitted_use
      t.integer :free_sign_up_credit
      t.integer :own_question_price
      t.integer :pre_build_test_price
      t.integer :web_cam_proctoring
      t.string :technical_support
      t.boolean :pre_build_question_banks
      t.boolean :create_unlimited_tests
      t.boolean :add_unlimited_questions_per_test
      t.boolean :add_your_own_basic_type_questions
      t.boolean :customize_test_reports
      t.boolean :multiple_user_access
      t.boolean :unlimited ,default: false
    end
  end

  def self.down
    drop_table :feature_sets
  end
end

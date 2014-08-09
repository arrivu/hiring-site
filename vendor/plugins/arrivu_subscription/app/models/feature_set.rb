class FeatureSet < ActiveRecord::Base


  attr_accessible :account_id,:name,:permitted_use,:free_sign_up_credit,:own_question_price,:pre_build_test_price,
                  :web_cam_proctoring,:technical_support,:pre_build_question_banks,:create_unlimited_tests,
                  :add_unlimited_questions_per_test,:add_your_own_basic_type_questions,:customize_test_reports,
                  :multiple_user_access,:unlimited


 validates_presence_of :name,:account_id

 belongs_to :account
 has_many :subscription_plans

end

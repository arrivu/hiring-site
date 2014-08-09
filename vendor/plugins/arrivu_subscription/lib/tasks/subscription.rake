namespace :db do

  task seed_subscription: :environment do
#   Billing types
    @domain_root_account = Account.default
    @domain_root_account.billing_types.create(billing_type: "annually",discount_percentage: '20',months: 12)
    @domain_root_account.billing_types.create(billing_type: "half-yearly",discount_percentage: '10',months: 6)
    @domain_root_account.billing_types.create(billing_type: "quarterly",discount_percentage: '5',months: 3)
    @domain_root_account.billing_types.create(billing_type: "month-by-month",discount_percentage: '0',months: 1)

    #   Feature sets
    @f1= FeatureSet.create(account_id: @domain_root_account.id,
                           name: "Standard",
                           permitted_use: 1,
                           free_sign_up_credit: 25,
                           own_question_price: 1,
                           pre_build_test_price: 3,
                           web_cam_proctoring: 2,
                           technical_support: "27x7",
                           pre_build_question_banks: true,
                           create_unlimited_tests: true,
                           add_unlimited_questions_per_test: true,
                           add_your_own_basic_type_questions: true,
                           customize_test_reports: false,
                           multiple_user_access: false,
                           unlimited: false)
    @f2= FeatureSet.create(account_id: @domain_root_account.id,
                           name: "Professional",
                           permitted_use: 12,
                           free_sign_up_credit: 30,
                           own_question_price: 1,
                           pre_build_test_price: 10,
                           web_cam_proctoring: 3,
                           technical_support: "27x7",
                           pre_build_question_banks: true,
                           create_unlimited_tests: true,
                           add_unlimited_questions_per_test: true,
                           add_your_own_basic_type_questions: true,
                           customize_test_reports: false,
                           multiple_user_access: false,
                           unlimited: false)

    SubscriptionPlan.create(account_id: @domain_root_account.id,
                            feature_set_id: @f1.id,
                            name: 'Standard',
                            rate_cents: 10000,
                            is_default: true

    )
    SubscriptionPlan.create(account_id: @domain_root_account.id,
                            feature_set_id: @f2.id,
                            name: 'Professional',
                            rate_cents: 100000

    )
  end


end

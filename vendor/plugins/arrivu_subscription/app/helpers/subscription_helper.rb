module SubscriptionHelper
  include ApplicationHelper
  # returns the daily cost of this plan.
  def daily_rate(options = {})
    yearly_rate(options) / 365
  end

  # returns the yearly cost of this plan.
  def yearly_rate(options = {})
    begin
      rate(options) * 12
    rescue
      rate * 12
    end
  end

  # returns the monthly cost of this plan.
  def monthly_rate(options = {})
    begin
      rate(options)
    rescue
      rate
    end
  end

  def paid?
    return false unless rate
    rate.cents > 0
  end

  def get_subscription
    @subscription = Subscription.find_by_account_id_and_subscribable_id_and_subscribable_type(@domain_root_account.id,
                                                                                              @account.id,Subscription::SUBSCRIBABLE_TYPE_ACCOUNT)
    if @subscription.nil?
       @subscription_plan = @domain_root_account.subscription_plans.default.first
       @subscription = Subscription.create!(account_id: @domain_root_account.id,
                                           subscription_plan_id: @subscription_plan.id,
                                           subscribable_id: @account.id,
                                           subscribable_type: Subscription::SUBSCRIBABLE_TYPE_ACCOUNT)


    end
  end

  def update_lms_account(account,subscription_plan)
    #account.settings[:no_students] = subscription_plan.feature_set.no_students
    #account.settings[:no_teachers] = subscription_plan.feature_set.no_teachers
    #account.settings[:no_admins] = subscription_plan.feature_set.no_admins
    #account.settings[:no_courses] = subscription_plan.feature_set.no_courses
    #account.default_storage_quota_mb = subscription_plan.feature_set.storage
    account.settings[:unlimited] = false unless subscription_plan.feature_set.unlimited == 'true'
    account.save
  end

end

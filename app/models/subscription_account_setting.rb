class SubscriptionAccountSetting < ActiveRecord::Base
  attr_accessible :subscription_id,:start_at,:end_at,:remarks
  belongs_to :subscription
end

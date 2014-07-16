class SubscriptionMessage < ActiveRecord::Base
  attr_accessible :subscription_id,:message
  belongs_to :subscription
end

class SubscriptionCredit < ActiveRecord::Base
  include SubscriptionHelper
  belongs_to :account
  belongs_to :subscription
  has_many :payments

  attr_accessible :subscription_id,:account_id,:amount
end
class SubscriptionCredit < ActiveRecord::Base
  include SubscriptionHelper
  belongs_to :account
  has_many :payments
end
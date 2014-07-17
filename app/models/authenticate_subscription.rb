class AuthenticateSubscription < ActiveRecord::Base

  attr_accessible :account_name,:unique_id,:password,:token
end

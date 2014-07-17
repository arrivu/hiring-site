class SubscriptionConfig < ActiveRecord::Base
  attr_accessible :email,:redirect_url
end

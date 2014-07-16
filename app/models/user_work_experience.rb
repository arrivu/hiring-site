class UserWorkExperience < ActiveRecord::Base
  belongs_to :user
  attr_accessible :organization,:from_date,
                  :end_date,:designation,
                  :permanent,
                  :reason_for_leaving,
                  :user_id
end

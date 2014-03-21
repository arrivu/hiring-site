class UserWorkExperience < ActiveRecord::Base
  attr_accessible :organization,:from_date,
                  :end_date,:designation,
                  :permanent,
                  :reason_for_leaving,
                  :user_id
end

class UserAcademic < ActiveRecord::Base
  #belongs_to :user_profile
  attr_accessible :degree,:discipline,
                  :college,:university,
                  :year_of_completion,
                  :percentage
end

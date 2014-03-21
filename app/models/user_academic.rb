class UserAcademic < ActiveRecord::Base
  belongs_to :user
  attr_accessible :degree,:discipline,
                  :college,:university,
                  :year_of_completion,
                  :percentage,
                  :user_id
end

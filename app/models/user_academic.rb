class UserAcademic < ActiveRecord::Base
  attr_accessible :degree,:discipline,
                  :college,:university,
                  :year_of_completion,
                  :percentage
end

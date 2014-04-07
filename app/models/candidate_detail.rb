class CandidateDetail < ActiveRecord::Base
  belongs_to :pseudonym
  belongs_to :course
  attr_accessible :first_name,:middle_name,
                  :last_name,:dob,
                  :contact_number,:email_id,
                  :address,:academics,
                  :employment,:current_compensation,
                  :expected_compensation, :profile_picture,
                  :project_id
end

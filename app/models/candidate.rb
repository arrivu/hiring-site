class Candidate < ActiveRecord::Base
  belongs_to :pseudonym
  belongs_to :course
  attr_accessible :first_name,:middle_name,
                  :last_name,:dob,
                  :contact_number,:email_id,
                  :address,:pg_degree,
                  :pg_discipline,:pg_college,
                  :pg_university,:pg_year,
                  :pg_cpga,:gr_degree,
                  :gr_discipline,:gr_college,
                  :gr_university,:gr_year,
                  :gr_cpga,:hsc_degree,
                  :hsc_discipline,:hsc_college,
                  :hsc_university,:hsc_year,
                  :hsc_cpga,:sc_degree,
                  :sc_discipline,:sc_college,
                  :sc_university,:sc_year,
                  :sc_cpga,:organization_a,
                  :from_a,:to_a,
                  :designation_a,:permanent_a,
                  :reason_a,:organization_b,
                  :from_b,:to_b,
                  :designation_b,:permanent_b,
                  :reason_b

end

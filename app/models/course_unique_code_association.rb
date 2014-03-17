class CourseUniqueCodeAssociation < ActiveRecord::Base
  belongs_to :course

  attr_accessible :course_id,:unique_access_code

end

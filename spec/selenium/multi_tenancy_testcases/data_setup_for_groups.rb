require File.expand_path(File.dirname(__FILE__) + '/spec_mt_helper')
require File.expand_path(File.dirname(__FILE__) + '/data_setup')


##### Groups creation

def ibm_course1_for_group
  ibm_course1_for_group=Course.find_by_name("IBM course M1 for Groups")
  if ibm_course1_for_group==nil
    ibm_course1_for_group=course(:course_name=>"IBM course M1 for Groups", :account=>ibm_account, :active_course=>true)
  end
  ibm_course1_for_group
end

def ibm_course2_for_group
  ibm_course2_for_group=Course.find_by_name("IBM course M2 for Groups")
  if ibm_course2_for_group==nil
    ibm_course2_for_group=course(:course_name=>"IBM course M2 for Groups", :account=>ibm_account, :active_course=>true)
  end
  ibm_course2_for_group

end

ibm_course1_for_group
ibm_course2_for_group

def tcs_course1_for_group
  tcs_course1_for_group=Course.find_by_name("TCS course M1 for Groups")
  if tcs_course1_for_group==nil
    tcs_course1_for_group=course(:course_name=>"TCS course M1 for Groups", :account=>tcs_account, :active_course=>true)
  end
  tcs_course1_for_group
end

def tcs_course2_for_group
  tcs_course2_for_group=Course.find_by_name("TCS course M2 for Groups")
  if tcs_course2_for_group==nil
    tcs_course2_for_group=course(:course_name=>"TCS course M2 for Groups", :account=>tcs_account, :active_course=>true)
  end
  tcs_course2_for_group

end

tcs_course1_for_group
tcs_course2_for_group


def ibm_course1_group1
  ibm_course1_group1=Group.find_by_name("Ibm Group1 for course1")
  if ibm_course1_group1==nil
    ibm_course1_group1=ibm_course1_for_group.groups.create!(:name => "Ibm Group1 for course1")
  end
  ibm_course1_group1
end

def ibm_course1_group2
  ibm_course1_group2=Group.find_by_name("Ibm Group2 for course1")
  if ibm_course1_group2==nil
    ibm_course1_group2=ibm_course1_for_group.groups.create!(:name => "Ibm Group2 for course1")
  end
  ibm_course1_group2
end

def ibm_course2_group1
  ibm_course2_group1=Group.find_by_name("Ibm Group1 for course2")
  if ibm_course2_group1==nil
    ibm_course2_group1=ibm_course2_for_group.groups.create!(:name => "Ibm Group1 for course2")
  end
  ibm_course2_group1
end

def ibm_course2_group2
  ibm_course2_group2=Group.find_by_name("Ibm Group2 for course2")
  if ibm_course2_group2==nil
    ibm_course2_group2=ibm_course2_for_group.groups.create!(:name => "Ibm Group2 for course2")
  end
  ibm_course2_group2
end




def tcs_course1_group1
  tcs_course1_group1=Group.find_by_name("Tcs Group1 for course1")
  if tcs_course1_group1==nil
    tcs_course1_group1=tcs_course1_for_group.groups.create!(:name => "Tcs Group1 for course1")
  end
  tcs_course1_group1
end

def tcs_course1_group2
  tcs_course1_group2=Group.find_by_name("Tcs Group2 for course1")
  if tcs_course1_group2==nil
    tcs_course1_group2=tcs_course1_for_group.groups.create!(:name => "Tcs Group2 for course1")
  end
  tcs_course1_group2
end

def tcs_course2_group1
  tcs_course2_group1=Group.find_by_name("Tcs Group1 for course2")
  if tcs_course2_group1==nil
    tcs_course2_group1=tcs_course2_for_group.groups.create!(:name => "Tcs Group1 for course2")
  end
  tcs_course2_group1
end

def tcs_course2_group2
  tcs_course2_group2=Group.find_by_name("Tcs Group2 for course2")
  if tcs_course2_group2==nil
    tcs_course2_group2=tcs_course2_for_group.groups.create!(:name => "Tcs Group2 for course2")
  end
  tcs_course2_group2
end



##### Student creation for IBM Domain
def ibm_student5
  add_user("ibm","ibm.st5@arrivusystems.com","Admin123$")
end

def ibm_student6
  add_user("ibm","ibm.st6@arrivusystems.com","Admin123$")
end
def ibm_student7
  add_user("ibm","ibm.st7@arrivusystems.com","Admin123$")
end

def ibm_student8
  add_user("ibm","ibm.st8@arrivusystems.com","Admin123$")
end

def tcs_student5
  add_user("tcs","tcs.st5@arrivusystems.com","Admin123$")
end

def tcs_student6
  add_user("tcs","tcs.st6@arrivusystems.com","Admin123$")
end
def tcs_student7
  add_user("tcs","tcs.st7@arrivusystems.com","Admin123$")
end

def tcs_student8
  add_user("tcs","tcs.st8@arrivusystems.com","Admin123$")
end
ibm_student5
ibm_student6
ibm_student7
ibm_student8

tcs_student5
tcs_student6
tcs_student7
tcs_student8

ibm_course1_for_group.enroll_user(ibm_teacher1,'TeacherEnrollment',:enrollment_state=>'active')
ibm_course1_for_group.enroll_user(ibm_teacher2,'TeacherEnrollment',:enrollment_state=>'active')
ibm_course1_for_group.enroll_user(ibm_student1,'StudentEnrollment',:enrollment_state=>'active')
ibm_course1_for_group.enroll_user(ibm_student2,'StudentEnrollment',:enrollment_state=>'active')
ibm_course1_for_group.enroll_user(ibm_student3,'StudentEnrollment',:enrollment_state=>'active')
ibm_course1_for_group.enroll_user(ibm_student4,'StudentEnrollment',:enrollment_state=>'active')

ibm_course2_for_group.enroll_user(ibm_teacher3,'TeacherEnrollment',:enrollment_state=>'active')
ibm_course2_for_group.enroll_user(ibm_teacher4,'TeacherEnrollment',:enrollment_state=>'active')
ibm_course2_for_group.enroll_user(ibm_student5,'StudentEnrollment',:enrollment_state=>'active')
ibm_course2_for_group.enroll_user(ibm_student6,'StudentEnrollment',:enrollment_state=>'active')
ibm_course2_for_group.enroll_user(ibm_student7,'StudentEnrollment',:enrollment_state=>'active')
ibm_course2_for_group.enroll_user(ibm_student8,'StudentEnrollment',:enrollment_state=>'active')

tcs_course1_for_group.enroll_user(tcs_teacher1,'TeacherEnrollment',:enrollment_state=>'active')
tcs_course1_for_group.enroll_user(tcs_teacher2,'TeacherEnrollment',:enrollment_state=>'active')
tcs_course1_for_group.enroll_user(tcs_student1,'StudentEnrollment',:enrollment_state=>'active')
tcs_course1_for_group.enroll_user(tcs_student2,'StudentEnrollment',:enrollment_state=>'active')
tcs_course1_for_group.enroll_user(tcs_student3,'StudentEnrollment',:enrollment_state=>'active')
tcs_course1_for_group.enroll_user(tcs_student4,'StudentEnrollment',:enrollment_state=>'active')

tcs_course2_for_group.enroll_user(tcs_teacher3,'TeacherEnrollment',:enrollment_state=>'active')
tcs_course2_for_group.enroll_user(tcs_teacher4,'TeacherEnrollment',:enrollment_state=>'active')
tcs_course2_for_group.enroll_user(tcs_student5,'StudentEnrollment',:enrollment_state=>'active')
tcs_course2_for_group.enroll_user(tcs_student6,'StudentEnrollment',:enrollment_state=>'active')
tcs_course2_for_group.enroll_user(tcs_student7,'StudentEnrollment',:enrollment_state=>'active')
tcs_course2_for_group.enroll_user(tcs_student8,'StudentEnrollment',:enrollment_state=>'active')


ibm_course1_group1.add_user(ibm_teacher1)
ibm_course1_group1.add_user(ibm_student1)
ibm_course1_group1.add_user(ibm_student2)

ibm_course1_group2.add_user(ibm_teacher2)
ibm_course1_group2.add_user(ibm_student3)
ibm_course1_group2.add_user(ibm_student4)

ibm_course2_group1.add_user(ibm_teacher3)
ibm_course2_group1.add_user(ibm_student5)
ibm_course2_group1.add_user(ibm_student6)

ibm_course2_group2.add_user(ibm_teacher4)
ibm_course2_group2.add_user(ibm_student7)
ibm_course2_group2.add_user(ibm_student8)


tcs_course1_group1.add_user(tcs_teacher1)
tcs_course1_group1.add_user(tcs_student1)
tcs_course1_group1.add_user(tcs_student2)

tcs_course1_group2.add_user(tcs_teacher2)
tcs_course1_group2.add_user(tcs_student3)
tcs_course1_group2.add_user(tcs_student4)

tcs_course2_group1.add_user(tcs_teacher3)
tcs_course2_group1.add_user(tcs_student5)
tcs_course2_group1.add_user(tcs_student6)

tcs_course2_group2.add_user(tcs_teacher4)
tcs_course2_group2.add_user(tcs_student7)
tcs_course2_group2.add_user(tcs_student8)





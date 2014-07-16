require File.expand_path(File.dirname(__FILE__) + '/spec_mt_helper')

##### Site Admin Creation

##### Account creation
def ibm_account
  add_mt_account("ibm")
end

def tcs_account
  add_mt_account("tcs")
end

def cisco_account
  add_mt_account("cisco")
end


def beacon_account
  add_mt_account("beacon")
end

def infosys_account
  add_mt_account("infosys")
end
ibm_account
tcs_account
cisco_account
beacon_account
infosys_account

##### Account Admin User creation
def ibm_admin_user
  add_mt_account_admin_users("ibm","ibm@arrivusystems.com","Admin123$")
end

def tcs_admin_user
  add_mt_account_admin_users("tcs","tcs@arrivusystems.com","Admin123$")
end

def cisco_admin_user
  add_mt_account_admin_users("cisco","cisco@arrivusystems.com","Admin123$")
end

def beacon_admin_user
  add_mt_account_admin_users("beacon","beacon@arrivusystems.com","Admin123$")
end

def infosys_admin_user
  add_mt_account_admin_users("infosys","infosys@arrivusystems.com","Admin123$")
end
ibm_admin_user
tcs_admin_user
cisco_admin_user
beacon_admin_user
infosys_admin_user





def ibm_sub_account1
  add_sub_account_mt("ibm","ibm_sub_account1","ibm.s1@arrivusystems.com","Admin123$")
end

def ibm_sub_account2
  add_sub_account_mt("ibm","ibm_sub_account2","ibm.s2@arrivusystems.com","Admin123$")
end


def tcs_sub_account1
  add_sub_account_mt("tcs","tcs_sub_account1","tcs.s1@arrivusystems.com","Admin123$")
end

def tcs_sub_account2
  add_sub_account_mt("tcs","tcs_sub_account2","tcs.s2@arrivusystems.com","Admin123$")
end


def cisco_sub_account1
  add_sub_account_mt("cisco","cisco_sub_account1","cisco.s1@arrivusystems.com","Admin123$")
end

def cisco_sub_account2
  add_sub_account_mt("cisco","cisco_sub_account2","cisco.s2@arrivusystems.com","Admin123$")
end


def beacon_sub_account1
  add_sub_account_mt("beacon","beacon_sub_account1","beacon.s1@arrivusystems.com","Admin123$")
end

def beacon_sub_account2
  add_sub_account_mt("beacon","beacon_sub_account2","beacon.s2@arrivusystems.com","Admin123$")
end


def infosys_sub_account1
  add_sub_account_mt("infosys","infosys_sub_account1","infosys.s1@arrivusystems.com","Admin123$")
end

def infosys_sub_account2
  add_sub_account_mt("infosys","infosys_sub_account2","infosys.s2@arrivusystems.com","Admin123$")
end

ibm_sub_account1
ibm_sub_account2

tcs_sub_account1
tcs_sub_account2

cisco_sub_account1
cisco_sub_account2

beacon_sub_account1
beacon_sub_account2

infosys_sub_account1
infosys_sub_account2


##### Ibm Domain Courses Creation

def ibm_course1
  ibm_course1=Course.find_by_name("IBM course M1-Main Account Course1")
  if ibm_course1==nil
    ibm_course1=course(:course_name=>"IBM course M1-Main Account Course1", :account=>ibm_account, :active_course=>true)
  end
  ibm_course1
end

def ibm_course2
  ibm_course2=Course.find_by_name("IBM course M2-Main Account Course2")
  if ibm_course2==nil
    ibm_course2=course(:course_name=>"IBM course M2-Main Account Course2", :account=>ibm_account, :active_course=>true)
  end
  ibm_course2

end

def ibm_course3
  ibm_course3=Course.find_by_name("IBM course M3-Main Account Course3")
  if ibm_course3==nil
    ibm_course3= course(:course_name=>"IBM course M3-Main Account Course3", :account=>ibm_account, :active_course=>true)
  end
  ibm_course3
end

def ibm_course4
  ibm_course4=Course.find_by_name("IBM course M4-Main Account Course4")
  if ibm_course4==nil
    ibm_course4=course(:course_name=>"IBM course M4-Main Account Course4", :account=>ibm_account, :active_course=>true)
  end
  ibm_course4
end

ibm_course1
ibm_course2
ibm_course3
ibm_course4

##### Tcs Domain Courses Creation
def
tcs_course1
  tcs_course1=Course.find_by_name("TCS course M1-Main Account Course1")
  if tcs_course1==nil
    tcs_course1=course(:course_name=>"TCS course M1-Main Account Course1", :account=>tcs_account, :active_course=>true)
  end
  tcs_course1

end

def tcs_course2
  tcs_course2=Course.find_by_name("TCS course M2-Main Account Course2")
  if tcs_course2==nil
    tcs_course2=course(:course_name=>"TCS course M2-Main Account Course2", :account=>tcs_account, :active_course=>true)
  end
  tcs_course2

end

def tcs_course3
  tcs_course3=Course.find_by_name("TCS course M3-Main Account Course3")
  if tcs_course3==nil
    tcs_course3=course(:course_name=>"TCS course M3-Main Account Course3", :account=>tcs_account, :active_course=>true)
  end
  tcs_course3

end

def tcs_course4
  tcs_course4=Course.find_by_name("TCS course M4-Main Account Course4")
  if tcs_course4==nil
    tcs_course4=course(:course_name=>"TCS course M4-Main Account Course4", :account=>tcs_account, :active_course=>true)
  end
  tcs_course4

end
tcs_course1
tcs_course2
tcs_course3
tcs_course4



##### Student creation for IBM Domain
def ibm_student1
  add_user("ibm","ibm.st1@arrivusystems.com","Admin123$")
end

def ibm_student2
  add_user("ibm","ibm.st2@arrivusystems.com","Admin123$")
end

def ibm_student3
  add_user("ibm","ibm.st3@arrivusystems.com","Admin123$")
end

def ibm_student4
  add_user("ibm","ibm.st4@arrivusystems.com","Admin123$")
end

def ibm_student5
  add_user("ibm","ibm.st5@arrivusystems.com","Admin123$")
end
ibm_student1
ibm_student2
ibm_student3
ibm_student4
ibm_student5


##### Teacher creation for IBM Domain
def ibm_teacher1
  add_user("ibm","ibm.tr1@arrivusystems.com","Admin123$")
end

def ibm_teacher2
  add_user("ibm","ibm.tr2@arrivusystems.com","Admin123$")
end

def ibm_teacher3
  add_user("ibm","ibm.tr3@arrivusystems.com","Admin123$")
end

def ibm_teacher4
  add_user("ibm","ibm.tr4@arrivusystems.com","Admin123$")
end

def ibm_teacher5
  add_user("ibm","ibm.tr5@arrivusystems.com","Admin123$")
end
ibm_teacher1
ibm_teacher2
ibm_teacher3
ibm_teacher4
ibm_teacher5


##### Student creation for TCS Domain
def tcs_student1
  add_user("tcs","tcs.st1@arrivusystems.com","Admin123$")
end

def tcs_student2
  add_user("tcs","tcs.st2@arrivusystems.com","Admin123$")
end

def tcs_student3
  add_user("tcs","tcs.st3@arrivusystems.com","Admin123$")
end

def tcs_student4
  add_user("tcs","tcs.st4@arrivusystems.com","Admin123$")
end

def tcs_student5
  add_user("tcs","tcs.st5@arrivusystems.com","Admin123$")
end
tcs_student1
tcs_student2
tcs_student3
tcs_student4
tcs_student5

##### Teacher creation for TCS Domain
def tcs_teacher1
  add_user("tcs","tcs.tr1@arrivusystems.com","Admin123$")
end

def tcs_teacher2
  add_user("tcs","tcs.tr2@arrivusystems.com","Admin123$")
end

def tcs_teacher3
  add_user("tcs","tcs.tr3@arrivusystems.com","Admin123$")
end

def tcs_teacher4
  add_user("tcs","tcs.tr4@arrivusystems.com","Admin123$")
end

def tcs_teacher5
  add_user("tcs","tcs.tr5@arrivusystems.com","Admin123$")
end
tcs_teacher1
tcs_teacher2
tcs_teacher3
tcs_teacher4
tcs_teacher5



##### Student creation for BEACON Domain
def beacon_student1
  add_user("beacon","beacon.st1@arrivusystems.com","Admin123$")
end

def beacon_student2
  add_user("beacon","beacon.st2@arrivusystems.com","Admin123$")
end

def beacon_student3
  add_user("beacon","beacon.st3@arrivusystems.com","Admin123$")
end

def beacon_student4
  add_user("beacon","beacon.st4@arrivusystems.com","Admin123$")
end

def beacon_student5
  add_user("beacon","beacon.st5@arrivusystems.com","Admin123$")
end
beacon_student1
beacon_student2
beacon_student3
beacon_student4
beacon_student5

##### Teacher creation for TCS Domain
def beacon_teacher1
  add_user("beacon","beacon.tr1@arrivusystems.com","Admin123$")
end

def beacon_teacher2
  add_user("beacon","beacon.tr2@arrivusystems.com","Admin123$")
end

def beacon_teacher3
  add_user("beacon","beacon.tr3@arrivusystems.com","Admin123$")
end

def beacon_teacher4
  add_user("beacon","beacon.tr4@arrivusystems.com","Admin123$")
end

def beacon_teacher5
  add_user("beacon","beacon.tr5@arrivusystems.com","Admin123$")
end
beacon_teacher1
beacon_teacher2
beacon_teacher3
beacon_teacher4
beacon_teacher5


##### Student creation for CISCO Domain
def cisco_student1
  add_user("cisco","cisco.st1@arrivusystems.com","Admin123$")
end

def cisco_student2
  add_user("cisco","cisco.st2@arrivusystems.com","Admin123$")
end

def cisco_student3
  add_user("cisco","cisco.st3@arrivusystems.com","Admin123$")
end

def cisco_student4
  add_user("cisco","cisco.st4@arrivusystems.com","Admin123$")
end

def cisco_student5
  add_user("cisco","cisco.st5@arrivusystems.com","Admin123$")
end
cisco_student1
cisco_student2
cisco_student3
cisco_student4
cisco_student5

##### Teacher creation for TCS Domain
def cisco_teacher1
  add_user("cisco","cisco.tr1@arrivusystems.com","Admin123$")
end

def cisco_teacher2
  add_user("cisco","cisco.tr2@arrivusystems.com","Admin123$")
end

def cisco_teacher3
  add_user("cisco","cisco.tr3@arrivusystems.com","Admin123$")
end

def cisco_teacher4
  add_user("cisco","cisco.tr4@arrivusystems.com","Admin123$")
end

def cisco_teacher5
  add_user("cisco","cisco.tr5@arrivusystems.com","Admin123$")
end
cisco_teacher1
cisco_teacher2
cisco_teacher3
cisco_teacher4
cisco_teacher5



##### Student creation for INFOSYS Domain
def infosys_student1
  add_user("infosys","infosys.st1@arrivusystems.com","Admin123$")
end

def infosys_student2
  add_user("infosys","infosys.st2@arrivusystems.com","Admin123$")
end

def infosys_student3
  add_user("infosys","infosys.st3@arrivusystems.com","Admin123$")
end

def infosys_student4
  add_user("infosys","infosys.st4@arrivusystems.com","Admin123$")
end

def infosys_student5
  add_user("infosys","infosys.st5@arrivusystems.com","Admin123$")
end
infosys_student1
infosys_student2
infosys_student3
infosys_student4
infosys_student5

##### Teacher creation for TCS Domain
def infosys_teacher1
  add_user("infosys","infosys.tr1@arrivusystems.com","Admin123$")
end

def infosys_teacher2
  add_user("infosys","infosys.tr2@arrivusystems.com","Admin123$")
end

def infosys_teacher3
  add_user("infosys","infosys.tr3@arrivusystems.com","Admin123$")
end

def infosys_teacher4
  add_user("infosys","infosys.tr4@arrivusystems.com","Admin123$")
end

def infosys_teacher5
  add_user("infosys","infosys.tr5@arrivusystems.com","Admin123$")
end
infosys_teacher1
infosys_teacher2
infosys_teacher3
infosys_teacher4
infosys_teacher5



##### Announcement Creation for Ibm domain

def ibm_course1_announcement
  ibm_course1_announcement = DiscussionTopic.find_by_title("IBM course1's Announcement by IBM teacher1")
  if ibm_course1_announcement == nil
    ibm_course1_announcement=ibm_course1.announcements.create!(:title => "IBM course1's Announcement by IBM teacher1",
                                    :message => "Welcome to Ibm Course1's Course", :user =>ibm_teacher1)
  end
  ibm_course1_announcement
end

def ibm_course2_announcement
  ibm_course2_announcement = DiscussionTopic.find_by_title("IBM course2's Announcement by IBM teacher2")
  if ibm_course2_announcement == nil
    ibm_course2_announcement=ibm_course2.announcements.create!(:title => "IBM course2's Announcement by IBM teacher2",
                                    :message => "Welcome to Ibm Course2's Course", :user =>ibm_teacher2)
  end
  ibm_course2_announcement
end

def ibm_course3_announcement
  ibm_course3_announcement = DiscussionTopic.find_by_title("IBM course3's Announcement by IBM teacher3")
  if ibm_course3_announcement == nil
    ibm_course3_announcement=ibm_course3.announcements.create!(:title => "IBM course3's Announcement by IBM teacher3",
                                    :message => "Welcome to Ibm Course3's Course", :user =>ibm_teacher3)
  end
  ibm_course3_announcement
end


def ibm_course4_announcement
  ibm_course4_announcement = DiscussionTopic.find_by_title("IBM course4's Announcement by IBM teacher4")
  if ibm_course4_announcement == nil
    ibm_course4_announcement=ibm_course4.announcements.create!(:title => "IBM course4's Announcement by IBM teacher4",
                                    :message => "Welcome to Ibm Course4's Course", :user =>ibm_teacher2)
  end
  ibm_course4_announcement
end
ibm_course1_announcement
ibm_course2_announcement
ibm_course3_announcement
ibm_course4_announcement

#### Announcement Creation for TCS domain

def tcs_course1_announcement
  tcs_course1_announcement=DiscussionTopic.find_by_title("TCS course1's Announcement by TCS teacher1")
  if  tcs_course1_announcement==nil
    tcs_course1_announcement=tcs_course1.announcements.create!(:title => "TCS course1's Announcement by TCS teacher1",
                                      :message => "Welcome to TCS Course1's Course", :user =>tcs_teacher1)
  end
  tcs_course1_announcement
end

def tcs_course2_announcement
  tcs_course2_announcement=DiscussionTopic.find_by_title("TCS course2's Announcement by TCS teacher2")
  if  tcs_course2_announcement==nil
    tcs_course2_announcement=tcs_course2.announcements.create!(:title => "TCS course2's Announcement by TCS teacher2",
                                   :message => "Welcome to TCS Course2's Course", :user =>tcs_teacher2)
  end
  tcs_course2_announcement
end

def tcs_course3_announcement
  tcs_course3_announcement=DiscussionTopic.find_by_title("TCS course3's Announcement by TCS teacher3")
  if  tcs_course3_announcement==nil
    tcs_course3_announcement=tcs_course3.announcements.create!(:title => "TCS course3's Announcement by TCS teacher3",
                                  :message => "Welcome to TCS Course3's Course", :user =>tcs_teacher3)
  end
  tcs_course3_announcement
end

def tcs_course4_announcement
  tcs_course4_announcement=DiscussionTopic.find_by_title("TCS course4's Announcement by TCS teacher4")
  if  tcs_course4_announcement==nil
    tcs_course4_announcement=tcs_course4.announcements.create!(:title => "TCS course4's Announcement by TCS teacher4",
                                  :message => "Welcome to TCS Course4's Course", :user =>tcs_teacher2)
  end
  tcs_course4_announcement
end
tcs_course1_announcement
tcs_course2_announcement
tcs_course3_announcement
tcs_course4_announcement

#### Assignment creation for IBM Domain

def ibm_course1_assignment
  ibm_course1_assignment=Assignment.find_by_title("IBM course1's assignment")
  if ibm_course1_assignment==nil
    ibm_course1_assignment=ibm_course1.assignments.create(:title => "IBM course1's assignment",:description=>"This is a test assignment description for IBM course1")
  end
  ibm_course1_assignment
end

def  ibm_course2_assignment
  ibm_course2_assignment=Assignment.find_by_title("IBM course2's assignment")
  if ibm_course2_assignment==nil
    ibm_course2_assignment=ibm_course2.assignments.create(:title => "IBM course2's assignment",:description=>"This is a test assignment description for IBM course2")
  end
  ibm_course2_assignment
end

def ibm_course3_assignment
  ibm_course3_assignment=Assignment.find_by_title("IBM course3's assignment")
  if ibm_course3_assignment ==nil
    ibm_course3_assignment=ibm_course3.assignments.create(:title => "IBM course3's assignment",:description=>"This is a test assignment description for IBM course3")
  end
  ibm_course3_assignment

end

def ibm_course4_assignment
  ibm_course4_assignment=Assignment.find_by_title("IBM course4's assignment")
  if ibm_course4_assignment==nil
  ibm_course4.assignments.create(:title => "IBM course4's assignment",:description=>"This is a test assignment description for IBM course4")
  end
  ibm_course4_assignment
end

ibm_course1_assignment
ibm_course2_assignment
ibm_course3_assignment
ibm_course4_assignment

####Assignment creation for TCS Domain

def tcs_course1_assignment
  tcs_course1_assignment=Assignment.find_by_title("TCS course1's assignment")
  if tcs_course1_assignment==nil
    tcs_course1_assignment=tcs_course1.assignments.create(:title => "TCS course1's assignment",:description=>"This is a test assignment description for TCS course1")
  end
  tcs_course1_assignment
end

def tcs_course2_assignment
  tcs_course2_assignment=Assignment.find_by_title("TCS course2's assignment")
  if tcs_course2_assignment==nil
    tcs_course2_assignment=tcs_course2.assignments.create(:title => "TCS course2's assignment",:description=>"This is a test assignment description for TCS course2")
  end
  tcs_course2_assignment

end

def tcs_course3_assignment
  tcs_course3_assignment=Assignment.find_by_title("TCS course3's assignment")
  if tcs_course3_assignment == nil
    tcs_course3_assignment=tcs_course3.assignments.create(:title => "TCS course3's assignment",:description=>"This is a test assignment description for TCS course3")
  end
  tcs_course3_assignment

end

def tcs_course4_assignment
  tcs_course4_assignment=Assignment.find_by_title("TCS course4's assignment")
  if tcs_course4_assignment==nil
    tcs_course4_assignment=tcs_course4.assignments.create(:title => "TCS course4's assignment",:description=>"This is a test assignment description for TCS course4")
  end
  tcs_course4_assignment
end

tcs_course1_assignment
tcs_course2_assignment
tcs_course3_assignment
tcs_course4_assignment



##### Discussion Topics creation for IBM domain

def ibm_course1_discussion_topic
  ibm_course1_discussion_topic=DiscussionTopic.find_by_title("IBM course1's Discussion Topic by IBM teacher1")
  if ibm_course1_discussion_topic==nil
    ibm_course1_discussion_topic=ibm_course1.discussion_topics.create!(:title => "IBM course1's Discussion Topic by IBM teacher1",
                                                                       :message => 'Discuss something about IBM course1', :user =>ibm_teacher1)
  end
  ibm_course1_discussion_topic
end

def ibm_course2_discussion_topic
  ibm_course2_discussion_topic=DiscussionTopic.find_by_title("IBM course2's Discussion Topic by IBM teacher2")
  if ibm_course2_discussion_topic==nil
    ibm_course2_discussion_topic=ibm_course2.discussion_topics.create!(:title => "IBM course2's Discussion Topic by IBM teacher2",
                                                                       :message => 'Discuss something about IBM course2', :user =>ibm_teacher2)
  end
  ibm_course2_discussion_topic
end

def ibm_course3_discussion_topic
  ibm_course3_discussion_topic=DiscussionTopic.find_by_title("IBM course3's Discussion Topic by IBM teacher3")
  if ibm_course3_discussion_topic==nil
    ibm_course3_discussion_topic=ibm_course3.discussion_topics.create!(:title => "IBM course3's Discussion Topic by IBM teacher3",
                                                                       :message => 'Discuss something about IBM course3', :user =>ibm_teacher3)
  end
  ibm_course3_discussion_topic
end

def ibm_course4_discussion_topic
  ibm_course4_discussion_topic=DiscussionTopic.find_by_title("IBM course4's Discussion Topic by IBM teacher4")
  if ibm_course4_discussion_topic==nil
    ibm_course4_discussion_topic=ibm_course4.discussion_topics.create!(:title => "IBM course4's Discussion Topic by IBM teacher4",
                                                                       :message => 'Discuss something about IBM course4', :user =>ibm_teacher4)
  end
  ibm_course4_discussion_topic
end


ibm_course1_discussion_topic
ibm_course2_discussion_topic
ibm_course3_discussion_topic
ibm_course4_discussion_topic


##### Disuccion Topic creation for TCS domain


def tcs_course1_discussion_topic
  tcs_course1_discussion_topic=DiscussionTopic.find_by_title("TCS course1's Discussion Topic by TCS teacher1")
  if tcs_course1_discussion_topic==nil
    tcs_course1_discussion_topic=tcs_course1.discussion_topics.create!(:title => "TCS course1's Discussion Topic by TCS teacher1",
                                                                       :message => 'Discuss something about TCS course1', :user =>tcs_teacher1)
  end
  tcs_course1_discussion_topic
end

def tcs_course2_discussion_topic
  tcs_course2_discussion_topic=DiscussionTopic.find_by_title("TCS course2's Discussion Topic by TCS teacher2")
  if tcs_course2_discussion_topic==nil
    tcs_course2_discussion_topic=tcs_course2.discussion_topics.create!(:title => "TCS course2's Discussion Topic by TCS teacher2",
                                                                       :message => 'Discuss something about TCS course2', :user =>tcs_teacher2)
  end
  tcs_course2_discussion_topic
end

def tcs_course3_discussion_topic
  tcs_course3_discussion_topic=DiscussionTopic.find_by_title("TCS course3's Discussion Topic by TCS teacher3")
  if tcs_course3_discussion_topic==nil
    tcs_course3_discussion_topic=tcs_course3.discussion_topics.create!(:title => "TCS course3's Discussion Topic by TCS teacher3",
                                                                       :message => 'Discuss something about TCS course3', :user =>tcs_teacher3)
  end
  tcs_course3_discussion_topic
end

def tcs_course4_discussion_topic
  tcs_course4_discussion_topic=DiscussionTopic.find_by_title("TCS course4's Discussion Topic by TCS teacher4")
  if tcs_course4_discussion_topic==nil
    tcs_course4_discussion_topic=tcs_course4.discussion_topics.create!(:title => "TCS course4's Discussion Topic by TCS teacher4",
                                                                       :message => 'Discuss something about TCS course4', :user =>tcs_teacher4)
  end
  tcs_course4_discussion_topic
end


tcs_course1_discussion_topic
tcs_course2_discussion_topic
tcs_course3_discussion_topic
tcs_course4_discussion_topic

### course enrollment
ibm_course1.enroll_user(ibm_student1,'StudentEnrollment',:enrollment_state=>'active')
ibm_course2.enroll_user(ibm_student2,'StudentEnrollment',:enrollment_state=>'active')
ibm_course3.enroll_user(ibm_student3,'StudentEnrollment',:enrollment_state=>'active')

ibm_course1.enroll_user(ibm_teacher1,'TeacherEnrollment',:enrollment_state=>'active')
ibm_course2.enroll_user(ibm_teacher2,'TeacherEnrollment',:enrollment_state=>'active')
ibm_course3.enroll_user(ibm_teacher3,'TeacherEnrollment',:enrollment_state=>'active')

ibm_course1.enroll_user(ibm_student3,'StudentEnrollment',:enrollment_state=>'active')
ibm_course2.enroll_user(ibm_student1,'StudentEnrollment',:enrollment_state=>'active')
ibm_course3.enroll_user(ibm_student2,'StudentEnrollment',:enrollment_state=>'active')

ibm_course1.enroll_user(ibm_teacher3,'TeacherEnrollment',:enrollment_state=>'active')
ibm_course2.enroll_user(ibm_teacher1,'TeacherEnrollment',:enrollment_state=>'active')
ibm_course3.enroll_user(ibm_teacher2,'TeacherEnrollment',:enrollment_state=>'active')



tcs_course1.enroll_user(tcs_student1,'StudentEnrollment',:enrollment_state=>'active')
tcs_course2.enroll_user(tcs_student2,'StudentEnrollment',:enrollment_state=>'active')
tcs_course3.enroll_user(tcs_student3,'StudentEnrollment',:enrollment_state=>'active')

tcs_course1.enroll_user(tcs_teacher1,'TeacherEnrollment',:enrollment_state=>'active')
tcs_course2.enroll_user(tcs_teacher2,'TeacherEnrollment',:enrollment_state=>'active')
tcs_course3.enroll_user(tcs_teacher3,'TeacherEnrollment',:enrollment_state=>'active')

tcs_course1.enroll_user(tcs_student3,'StudentEnrollment',:enrollment_state=>'active')
tcs_course2.enroll_user(tcs_student1,'StudentEnrollment',:enrollment_state=>'active')
tcs_course3.enroll_user(tcs_student2,'StudentEnrollment',:enrollment_state=>'active')

tcs_course1.enroll_user(tcs_teacher3,'TeacherEnrollment',:enrollment_state=>'active')
tcs_course2.enroll_user(tcs_teacher1,'TeacherEnrollment',:enrollment_state=>'active')
tcs_course3.enroll_user(tcs_teacher2,'TeacherEnrollment',:enrollment_state=>'active')

###teacher as a student enrollment
ibm_course4.enroll_user(ibm_teacher1,"StudentEnrollment",:enrollment_state=>'active')
tcs_course4.enroll_user(ibm_teacher1,"StudentEnrollment",:enrollment_state=>'active')
ibm_course4.enroll_user(tcs_teacher1,"StudentEnrollment",:enrollment_state=>'active')
tcs_course4.enroll_user(tcs_teacher1,"StudentEnrollment",:enrollment_state=>'active')



##### Grading standards creation

def ibm_grade_book
  ibm_grade_book = GradingStandard.find_by_title("IBM Grade Book")
  if ibm_grade_book==nil
    ibm_grade_book=ibm_account.grading_standards.create!(:title => "IBM Grade Book", :standard_data => {:a => {:name => 'A', :value => '95'}, :b => {:name => 'B', :value => '80'}, :f => {:name => 'F', :value => '50'}})
  end
  ibm_grade_book
end

def tcs_grade_book
  tcs_grade_book = GradingStandard.find_by_title("TCS Grade Book")
  if tcs_grade_book==nil
    tcs_grade_book=tcs_account.grading_standards.create!(:title => "TCS Grade Book", :standard_data => {:a => {:name => 'A', :value => '95'}, :b => {:name => 'B', :value => '80'}, :f => {:name => 'F', :value => '50'}})
  end
  tcs_grade_book
end


def cisco_grade_book
  cisco_grade_book = GradingStandard.find_by_title("CISCO Grade Book")
  if cisco_grade_book==nil
    cisco_grade_book=cisco_account.grading_standards.create!(:title => "CISCO Grade Book", :standard_data => {:a => {:name => 'A', :value => '95'}, :b => {:name => 'B', :value => '80'}, :f => {:name => 'F', :value => '50'}})
  end
  cisco_grade_book

end


def beacon_grade_book
  beacon_grade_book = GradingStandard.find_by_title("BEACON Grade Book")
  if beacon_grade_book==nil
    beacon_grade_book=beacon_account.grading_standards.create!(:title => "BEACON Grade Book", :standard_data => {:a => {:name => 'A', :value => '95'}, :b => {:name => 'B', :value => '80'}, :f => {:name => 'F', :value => '50'}})
  end
  beacon_grade_book
end


def infosys_grade_book
  infosys_grade_book = GradingStandard.find_by_title("INFOSYS Grade Book")
  if infosys_grade_book==nil
    infosys_grade_book=infosys_account.grading_standards.create!(:title => "INFOSYS Grade Book", :standard_data => {:a => {:name => 'A', :value => '95'}, :b => {:name => 'B', :value => '80'}, :f => {:name => 'F', :value => '50'}})
  end
  infosys_grade_book
end


ibm_grade_book
tcs_grade_book
cisco_grade_book
beacon_grade_book
infosys_grade_book

##### Outcome creation

def ibm_account_level_outcome
  create_outcome(ibm_account,"ibm account level outcome","ibm account level outcome for selenium testing")
end

def tcs_account_level_outcome
  create_outcome(tcs_account,"tcs account level outcome","tcs account level outcome for selenium testing")
end

def ibm_course1_outcome
  create_outcome(ibm_course1,"ibm course1 outcome","ibm course1 level outcome for selenium testing")
end

def ibm_course2_outcome
  create_outcome(ibm_course2,"ibm course2 outcome","ibm course2 level outcome for selenium testing")
end

def ibm_course3_outcome
  create_outcome(ibm_course3,"ibm course3 outcome","ibm course3 level outcome for selenium testing")
end

def ibm_course4_outcome
  create_outcome(ibm_course4,"ibm course4 outcome","ibm course4 level outcome for selenium testing")
end


def tcs_course1_outcome
  create_outcome(tcs_course1,"tcs course1 outcome","tcs course1 level outcome for selenium testing")
end

def tcs_course2_outcome
  create_outcome(tcs_course2,"tcs course2 outcome","tcs course2 level outcome for selenium testing")
end

def tcs_course3_outcome
  create_outcome(tcs_course3,"tcs course3 outcome","tcs course3 level outcome for selenium testing")
end

def tcs_course4_outcome
  create_outcome(tcs_course4,"tcs course4 outcome","tcs course4 level outcome for selenium testing")
end

ibm_account_level_outcome
tcs_account_level_outcome

ibm_course1_outcome
ibm_course2_outcome
ibm_course3_outcome
ibm_course4_outcome

tcs_course1_outcome
tcs_course2_outcome
tcs_course3_outcome
tcs_course4_outcome



def login_warning_message
  driver.find_element(:id,"login_form").should be_displayed
  driver.find_element(:id,"unauthorized_message").should be_displayed
  f('.ui-state-error').should include_text("Please Log In")
  driver.find_element(:id,"pseudonym_session_unique_id").should be_displayed
  driver.find_element(:id,"pseudonym_session_password").should be_displayed
end

def unauthorized_warning_message
  driver.find_element(:id,"unauthorized_holder").should be_displayed
  driver.find_element(:id,"unauthorized_message").should be_displayed
  f('.ui-state-error').should include_text("Unauthorized")
end
































###############################################

####### Files Creation
#
#def ibm_course1_file
#  ibm_student1_file=Attachment.find_by_display_name("ibm_course1_doc")
#  if ibm_student1_file==nil
#    ibm_student1_file=add_file(uploaded_data("ibm_course1_doc.doc"),ibm_course1, "ibm_course1_doc")
#  end
#  ibm_student1_file
#end
#
#def ibm_course2_file
#  ibm_student2_file=Attachment.find_by_display_name("ibm_course2_doc")
#  if ibm_student2_file==nil
#    ibm_student2_file=add_file(uploaded_data("ibm_course2_doc.doc"),ibm_course2, "ibm_course2_doc")
#  end
#  ibm_student2_file
#end
#
#def ibm_course3_file
#  ibm_student3_file=Attachment.find_by_display_name("ibm_course3_doc")
#  if ibm_student3_file==nil
#    ibm_student3_file=add_file(uploaded_data("ibm_course3_doc.doc"),ibm_course3, "ibm_course3_doc")
#  end
#  ibm_student3_file
#end
#
#
#def ibm_course4_file
#  ibm_student4_file=Attachment.find_by_display_name("ibm_course4_doc")
#  if ibm_student4_file==nil
#   ibm_student4_file=add_file(uploaded_data("ibm_course4_doc.doc"),ibm_course3, "ibm_course4_doc")
#  end
#  ibm_student4_file
#end
#
#
#def tcs_course1_file
#  tcs_student1_file=Attachment.find_by_display_name("tcs_course1_doc")
#  if tcs_student1_file==nil
#    add_file(uploaded_data("tcs_course1_doc.doc.doc"),tcs_course1, "tcs_course1_doc")
#  end
#  tcs_student1_file
#end
#
#def tcs_course2_file
#  tcs_student2_file=Attachment.find_by_display_name("tcs_course2_doc")
#  if tcs_student2_file==nil
#    add_file(uploaded_data("tcs_course2_doc.doc.doc"),tcs_course2, "tcs_course2_doc")
#  end
#  tcs_student2_file
#end
#
#def tcs_course3_file
#  tcs_student3_file=Attachment.find_by_display_name("tcs_course3_doc")
#  if tcs_student3_file==nil
#    add_file(uploaded_data("tcs_course3_doc.doc.doc"),tcs_course3, "tcs_course3_doc")
#  end
#  tcs_student3_file
#end
#
#
#def tcs_course4_file
#  tcs_student4_file=Attachment.find_by_display_name("tcs_course4_doc")
#  if tcs_student4_file==nil
#    add_file(uploaded_data("tcs_course4_doc.doc.doc"),tcs_course3, "tcs_course4_doc")
#  end
#  tcs_student4_file
#end
#
#ibm_course1_file
#ibm_course2_file
#ibm_course3_file
#ibm_course4_file
#
#tcs_course1_file
#tcs_course2_file
#tcs_course3_file
#tcs_course4_file



###############################################

###############################################
###### IBM Wiki pages creation
#
#def ibm_course1_wiki_page
#  ibm_course1_wiki_page=Wiki.find_by_title("IBM course1's wiki page")
#  if ibm_course1_wiki_page==nil
#    ibm_course1_wiki_page=ibm_course1.wiki.wiki_pages.create(:title => "IBM course1's wiki page", :hide_from_students => :false, :editing_roles => "public", :notify_of_update => true)
#  end
#  ibm_course1_wiki_page
#end
#
#def ibm_course2_wiki_page
#  ibm_course2_wiki_page=Wiki.find_by_title("IBM course2's wiki page")
#  if ibm_course2_wiki_page==nil
#    ibm_course2_wiki_page=ibm_course2.wiki.wiki_pages.create(:title => "IBM course2's wiki page", :hide_from_students => :false, :editing_roles => "public", :notify_of_update => true)
#  end
#  ibm_course2_wiki_page
#end
#
#def ibm_course3_wiki_page
#  ibm_course3_wiki_page=Wiki.find_by_title("IBM course3's wiki page")
#  if ibm_course3_wiki_page==nil
#    ibm_course3_wiki_page=ibm_course3.wiki.wiki_pages.create(:title => "IBM course3's wiki page", :hide_from_students => :false, :editing_roles => "public", :notify_of_update => true)
#  end
#  ibm_course3_wiki_page
#end
#
#def ibm_course4_wiki_page
#  ibm_course4_wiki_page=Wiki.find_by_title("IBM course4's wiki page")
#  if ibm_course4_wiki_page==nil
#    ibm_course4_wiki_page=ibm_course4.wiki.wiki_pages.create(:title => "IBM course4's wiki page", :hide_from_students => :false, :editing_roles => "public", :notify_of_update => true)
#  end
#  ibm_course4_wiki_page
#end
#
#ibm_course1_wiki_page
#ibm_course2_wiki_page
#ibm_course3_wiki_page
#ibm_course4_wiki_page
#
###### TCS Wiki pages creation
#
#def tcs_course1_wiki_page
#  tcs_course1_wiki_page=Wiki.find_by_title("TCS course1's wiki page")
#  if tcs_course1_wiki_page==nil
#    tcs_course1_wiki_page=tcs_course1.wiki.wiki_pages.create(:title => "TCS course1's wiki page", :hide_from_students => :false, :editing_roles => "public", :notify_of_update => true)
#  end
#  tcs_course1_wiki_page
#end
#
#def tcs_course2_wiki_page
#  tcs_course2_wiki_page=Wiki.find_by_title("TCS course2's wiki page")
#  if tcs_course2_wiki_page==nil
#    tcs_course2_wiki_page=tcs_course2.wiki.wiki_pages.create(:title => "TCS course2's wiki page", :hide_from_students => :false, :editing_roles => "public", :notify_of_update => true)
#  end
#  tcs_course2_wiki_page
#end
#
#def tcs_course3_wiki_page
#  tcs_course3_wiki_page=Wiki.find_by_title("TCS course3's wiki page")
#  if tcs_course3_wiki_page==nil
#    tcs_course3_wiki_page=tcs_course3.wiki.wiki_pages.create(:title => "TCS course3's wiki page", :hide_from_students => :false, :editing_roles => "public", :notify_of_update => true)
#  end
#  tcs_course3_wiki_page
#end
#
#def tcs_course4_wiki_page
#  tcs_course4_wiki_page=Wiki.find_by_title("TCS course4's wiki page")
#  if tcs_course4_wiki_page==nil
#    tcs_course4_wiki_page=tcs_course4.wiki.wiki_pages.create(:title => "TCS course4's wiki page", :hide_from_students => :false, :editing_roles => "public", :notify_of_update => true)
#  end
#  tcs_course4_wiki_page
#end
#
#tcs_course1_wiki_page
#tcs_course2_wiki_page
#tcs_course3_wiki_page
#tcs_course4_wiki_page



#########################################################################################

#########################################################################################
#                                                                                       #
#           teacher as a student in another doamin to login in another domain           #
#                                                                                       #
#########################################################################################

#### for checking

#ibm_course4.enroll_student(ibm_teacher1).accept!
#ibm_course4.enroll_student(tcs_teacher1).accept!
#tcs_course4.enroll_student(tcs_teacher1).accept!
#tcs_course4.enroll_student(ibm_teacher1).accept!

#
#def add_teacher_as_student(account_name,email,password)
#  #@account=Account.find_by_name(account_name)
#  #@user=User.find_by_name(email)
#  #@account_id=Pseudonym.find_account_id(@account.id)
#  #if @user != nil && @account_id==nil
#  #  @user
#  #else
#  #  @account = Account.find_by_name(account_name)
#  #  @user=User.create!(:name => email,:sortable_name => email)
#  #  pseudonym = @user.pseudonyms.create!(:unique_id => email,:password => password, :password_confirmation => password,:account => @account )
#  #  @user.communication_channels.create!(:path => email) { |cc| cc.workflow_state = 'active' }
#  #  puts "Creating user #{email} ..."
#  #end
#
#    @account = Account.find_by_name(account_name)
#    @user=User.create!(:name => email,:sortable_name => email)
#    pseudonym = @user.pseudonyms.create!(:unique_id => email,:password => password, :password_confirmation => password,:account => @account )
#    @user.communication_channels.create!(:path => email) { |cc| cc.workflow_state = 'active' }
#    puts "Creating user #{email} ..."
#   @user
#
#end


#def ibm_teacher1_as_student_in_tcs
#  ibm_teacher1_as_student_in_tcs=Enrollment.find_by_user_id_and_course_id(ibm_teacher1.id,ibm_course4.id)
#  if ibm_teacher1_as_student_in_tcs==nil
#  add_teacher_as_student("tcs","ibm.tr1@arrivusystems.com","Admin123$")
#  end
#
#end
#
#def tcs_teacher1_as_student_in_ibm
#  tcs_teacher1_as_student_in_ibm=Enrollment.find_by_user_id_and_course_id(tcs_teacher1.id,tcs_course4.id)
#  if tcs_teacher1_as_student_in_ibm==nil
#  add_teacher_as_student("ibm","tcs.tr1@arrivusystems.com","Admin123$")
#  end
#end
#ibm_teacher1_as_student_in_tcs
#tcs_teacher1_as_student_in_ibm
#
#
#ibm_course4.enroll_user(ibm_teacher1,"StudentEnrollment",:enrollment_state=>'active')
#tcs_course4.enroll_user(tcs_teacher1,"StudentEnrollment",:enrollment_state=>'active')
#ibm_course4.enroll_user(tcs_teacher1_as_student_in_ibm,"StudentEnrollment",:enrollment_state=>'active')
#tcs_course4.enroll_user(ibm_teacher1_as_student_in_tcs,"StudentEnrollment",:enrollment_state=>'active')

###### Test cases for teacher as student login in two or more domains
#it "should login as student IBM teacher1 enrolled as a student in other courses of same domain" do
#  assignment_check_by_student(:account_name=>"tcs",:user_name=>"ibm.tr1@arrivusystems.com",:assignment_ids=>[tcs_course4_assignment.id])
#end
#
#it "should login as student IBM teacher1 enrolled as a student in other courses of same domain" do
#  assignment_check_by_student(:account_name=>"ibm",:user_name=>"tcs.tr1@arrivusystems.com",:assignment_ids=>[ibm_course4_assignment.id])
#end
#



#########################################################################################################################

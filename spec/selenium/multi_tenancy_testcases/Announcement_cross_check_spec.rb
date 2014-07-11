require File.expand_path(File.dirname(__FILE__) + '/common_mt')
require File.expand_path(File.dirname(__FILE__) + '/data_setup')

describe "Announcement_Cross_Check_Creation" do

  it_should_behave_like "in-process server selenium tests"



  ##Account creation
  #
  #ibm_account=add_mt_account("ibm")
  #tcs_account=add_mt_account("tcs")
  #
  ##Admin Creation
  #ibm_admin_user=add_mt_account_admin_users("ibm","ibm@arrivusystems.com","Admin123$")
  #tcs_admin_user=add_mt_account_admin_users("tcs","tcs@arrivusystems.com","Admin123$")
  #
  ##IBM Course creation
  #ibm_course1=course(:course_name=>"IBM Course1",:account=>ibm_account,:active_course=>true)
  #ibm_course2=course(:course_name=>"IBM Course2",:account=>ibm_account,:active_course=>true)
  #ibm_course3=course(:course_name=>"IBM Course3",:account=>ibm_account,:active_course=>true)
  #ibm_course4=course(:course_name=>"IBM Course4",:account=>ibm_account,:active_course=>true)
  #
  ##tcs creation
  #tcs_course1=course(:course_name=>"TCS_Course1",:account=>tcs_account,:active_course=>true)
  #tcs_course2=course(:course_name=>"TCS_Course2",:account=>tcs_account,:active_course=>true)
  #tcs_course3=course(:course_name=>"TCS_Course3",:account=>tcs_account,:active_course=>true)
  #tcs_course4=course(:course_name=>"TCS Course4",:account=>tcs_account,:active_course=>true)
  #
  #
  ##student creation
  #ibm_student1=add_user("ibm","ibm.st1@arrivusystems.com","Admin123$")
  #ibm_student2=add_user("ibm","ibm.st2@arrivusystems.com","Admin123$")
  #ibm_student3=add_user("ibm","ibm.st3@arrivusystems.com","Admin123$")
  #
  #
  #tcs_student1=add_user("tcs","tcs.st1@arrivusystems.com","Admin123$")
  #tcs_student2=add_user("tcs","tcs.st2@arrivusystems.com","Admin123$")
  #tcs_student3=add_user("tcs","tcs.st3@arrivusystems.com","Admin123$")
  #
  #
  ##teacher creation
  #ibm_teacher1=add_user("ibm","ibm.tr1@arrivusystems.com","Admin123$")
  #ibm_teacher2=add_user("ibm","ibm.tr2@arrivusystems.com","Admin123$")
  #ibm_teacher3=add_user("ibm","ibm.tr3@arrivusystems.com","Admin123$")
  #
  #tcs_teacher1=add_user("tcs","tcs.tr1@arrivusystems.com","Admin123$")
  #tcs_teacher2=add_user("tcs","tcs.tr2@arrivusystems.com","Admin123$")
  #tcs_teacher3=add_user("tcs","tcs.tr3@arrivusystems.com","Admin123$")
  #
  #
  ###Announcement Creation
  #
  #ibm_course1_announcement=ibm_course1.announcements.create!(:title => "ibm_course1's Announcement by teacher1",
  #                                  :message => "Welcome to Ibm_course1's Course", :user =>ibm_teacher1)
  #
  #ibm_course2_announcement=ibm_course2.announcements.create!(:title => "ibm_course2's Announcement by teacher2",
  #                                  :message => "Announcement for Ibm_course2's Course Students", :user =>ibm_teacher2)
  #
  #ibm_course3_announcement=ibm_course3.announcements.create!(:title => "ibm_course3's Announcement by teacher3",
  #                                  :message => "Teacher3 announcement for ibm_course3", :user =>ibm_teacher3)
  #
  #ibm_course4_announcement=ibm_course4.announcements.create!(:title => "ibm_course4's Announcement by teacher4",
  #                                                           :message => "Teacher2 announcement for ibm_course4", :user =>ibm_teacher2)
  #
  #
  #
  #
  #tcs_course1_announcement=tcs_course1.announcements.create!(:title => "tcs_course1's Announcement by teacher1",
  #                                                           :message => "Welcome to Ibm_course1's Course", :user =>tcs_teacher1)
  #
  #tcs_course2_announcement=tcs_course2.announcements.create!(:title => "tcs_course2's Announcement by teacher2",
  #                                                           :message => "Announcement for Ibm_course2's Course Students", :user =>tcs_teacher2)
  #
  #tcs_course3_announcement=tcs_course3.announcements.create!(:title => "tcs_course3's Announcement by teacher3",
  #                                                           :message => "Teacher3 announcement for tcs_course3", :user =>tcs_teacher3)
  #
  #tcs_course4_announcement=tcs_course4.announcements.create!(:title => "tcs_course4's Announcement by teacher4",
  #                                                          :message => "Teacher2 announcement for tcs_course4", :user =>tcs_teacher2)
  #
  #
  ##course enrollment
  #ibm_course1.enroll_user(ibm_student1,'StudentEnrollment',:enrollment_state=>'active')
  #ibm_course2.enroll_user(ibm_student2,'StudentEnrollment',:enrollment_state=>'active')
  #ibm_course3.enroll_user(ibm_student3,'StudentEnrollment',:enrollment_state=>'active')
  #
  #ibm_course1.enroll_user(ibm_teacher1,'TeacherEnrollment',:enrollment_state=>'active')
  #ibm_course2.enroll_user(ibm_teacher2,'TeacherEnrollment',:enrollment_state=>'active')
  #ibm_course3.enroll_user(ibm_teacher3,'TeacherEnrollment',:enrollment_state=>'active')
  #
  #ibm_course1.enroll_user(ibm_student3,'StudentEnrollment',:enrollment_state=>'active')
  #ibm_course2.enroll_user(ibm_student1,'StudentEnrollment',:enrollment_state=>'active')
  #ibm_course3.enroll_user(ibm_student2,'StudentEnrollment',:enrollment_state=>'active')
  #
  #ibm_course1.enroll_user(ibm_teacher3,'TeacherEnrollment',:enrollment_state=>'active')
  #ibm_course2.enroll_user(ibm_teacher1,'TeacherEnrollment',:enrollment_state=>'active')
  #ibm_course3.enroll_user(ibm_teacher2,'TeacherEnrollment',:enrollment_state=>'active')
  #
  #
  #
  #tcs_course1.enroll_user(tcs_student1,'StudentEnrollment',:enrollment_state=>'active')
  #tcs_course2.enroll_user(tcs_student2,'StudentEnrollment',:enrollment_state=>'active')
  #tcs_course3.enroll_user(tcs_student3,'StudentEnrollment',:enrollment_state=>'active')
  #
  #tcs_course1.enroll_user(tcs_teacher1,'TeacherEnrollment',:enrollment_state=>'active')
  #tcs_course2.enroll_user(tcs_teacher2,'TeacherEnrollment',:enrollment_state=>'active')
  #tcs_course3.enroll_user(tcs_teacher3,'TeacherEnrollment',:enrollment_state=>'active')
  #
  #tcs_course1.enroll_user(tcs_student3,'StudentEnrollment',:enrollment_state=>'active')
  #tcs_course2.enroll_user(tcs_student1,'StudentEnrollment',:enrollment_state=>'active')
  #tcs_course3.enroll_user(tcs_student2,'StudentEnrollment',:enrollment_state=>'active')
  #
  #tcs_course1.enroll_user(tcs_teacher3,'TeacherEnrollment',:enrollment_state=>'active')
  #tcs_course2.enroll_user(tcs_teacher1,'TeacherEnrollment',:enrollment_state=>'active')
  #tcs_course3.enroll_user(tcs_teacher2,'TeacherEnrollment',:enrollment_state=>'active')
  #
  ##cross check for enrollment
  #ibm_course4.enroll_user(ibm_teacher1,"StudentEnrollment",:enrollment_state=>'active')
  #tcs_course4.enroll_user(tcs_teacher1,"StudentEnrollment",:enrollment_state=>'active')
  #
  #ibm_course4.enroll_user(tcs_teacher1,"StudentEnrollment",:enrollment_state=>'active')
  #tcs_course4.enroll_user(ibm_teacher1,"StudentEnrollment",:enrollment_state=>'active')





  def course_check_by_user(params={})
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form(params[:user_name],"Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == params[:user_name]
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{params[:course_id]}/announcements"
    sleep 2
    #expect_new_page_load{driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{params[:course_id]}/announcements"
    announcement_details=DiscussionTopic.find(params[:announcement_id])
    author_name=User.find(announcement_details.user_id).name
    course_code=Course.find(params[:course_id]).course_code
    f("#section-tabs-header").text.should include_text course_code
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{params[:course_id]}/discussion_topics/#{params[:announcement_id]}"
    f('.discussion-title').should include_text announcement_details.title
    f('.author').should include_text author_name
    f('.message.user_content.enhanced').should include_text announcement_details.message
    #driver.find_element(:id,"collapseAll").should be_displayed
    #driver.find_element(:id,"expandAll").should be_displayed
    if params[:user_role]=="student"
      f('.btn.edit-btn').should be_nil
    elsif params[:user_role]=="teacher"
      f('.btn.edit-btn').should be_displayed
    end
    expect_new_page_load { f('.logout > a').click }
   end

  def course_check_by_admin(params={})
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form(params[:user_name],"Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == params[:user_name]
      driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{params[:course_id]}/announcements"
      sleep 5
      announcement_details=DiscussionTopic.find(params[:announcement_id])
      #announcement_title=DiscussionTopic.find(params[:announcement_id]).title
      #announcement_message=DiscussionTopic.find(params[:announcement_id]).message
      author_name=User.find(announcement_details.user_id).name
      course_code=Course.find(params[:course_id]).course_code
      f("#section-tabs-header").text.should include_text course_code
      # driver.find_element(:id,'new-discussion-btn').should be_displayed
      #driver.find_element(:id,"#{params[:announcement_id]}").should include_text("#{params[:announcement_details.title]}")
      driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{params[:course_id]}/discussion_topics/#{params[:announcement_id]}"
      f('.discussion-title').should include_text announcement_details.title
      f('.author').should include_text author_name
      # fj("p:contains('#{params[:announcement_id.message]}')").should be_displayed
      f('.message.user_content.enhanced').should include_text announcement_details.message
      expect_new_page_load { f('.logout > a').click }

  end

  def course_cross_check_by_admin(params={})
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form(params[:user_name],"Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == params[:user_name]
    if params[:access_type]=="change course id"
      driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{params[:course_id]}/announcements/#{params[:announcement_id]}"
      sleep 3
      driver.find_element(:id,"unauthorized_holder").should be_displayed
      driver.find_element(:id,"unauthorized_message").should be_displayed
      f('.ui-state-error').should include_text("Unauthorized")
      #driver.find_element(:id,"unauthorized_message").should include_text("Unauthorized It appears that you don't have permission to access this page. Please make sure you're authorized to view this content.")
    end
    if params[:access_type]=="change url"
      driver.get "http://#{params[:cross_account_name]}.lvh.me:#{$server_port}/courses/#{params[:course_id]}/announcements/#{params[:announcement_id]}"
      sleep 3
      #driver.find_element(:id,"unauthorized_message").should be_displayed
      driver.find_element(:id,"login_form").should be_displayed
      f('.ui-state-error').should include_text("Please Log In")
      driver.find_element(:id,"pseudonym_session_unique_id").should be_displayed
      driver.find_element(:id,"pseudonym_session_password").should be_displayed

    end

  end

  def course_cross_check_by_user(params={})
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form(params[:user_name],"Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == params[:user_name]

      if params[:access_type]=="change course id"

        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{params[:course_id]}/announcements/#{params[:announcement_id]}"
        sleep 3
        driver.find_element(:id,"unauthorized_holder").should be_displayed
        driver.find_element(:id,"unauthorized_message").should be_displayed
        f('.ui-state-error').should include_text("Unauthorized")
      end
      if params[:access_type]=="change course url"
        driver.get "http://#{params[:cross_account_name]}.lvh.me:#{$server_port}/courses/#{params[:course_id]}/announcements/#{params[:announcement_id]}"
        sleep 3
        #driver.find_element(:id,"unauthorized_message").should be_displayed
        driver.find_element(:id,"login_form").should be_displayed
        f('.ui-state-error').should include_text("Please Log In")
        driver.find_element(:id,"pseudonym_session_unique_id").should be_displayed
        driver.find_element(:id,"pseudonym_session_password").should be_displayed

      end

    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    expect_new_page_load { f('.logout > a').click }


  end

  def teacher_as_a_student(params={})
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form(params[:user_name],"Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == params[:user_name]
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{params[:course_id]}/announcements"
    sleep 2
    #expect_new_page_load{driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{params[:course_id]}/announcements"
    announcement_details=DiscussionTopic.find(params[:announcement_id])
    author_name=User.find(announcement_details.user_id).name
    course_code=Course.find(params[:course_id]).course_code
    f("#section-tabs-header").text.should include_text course_code
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{params[:course_id]}/discussion_topics/#{params[:announcement_id]}"
    f('.discussion-title').should include_text announcement_details.title
    f('.author').should include_text author_name
    f('.message.user_content.enhanced').should include_text announcement_details.message
    #driver.find_element(:id,"collapseAll").should be_displayed
    #driver.find_element(:id,"expandAll").should be_displayed
    if params[:user_role]=="student"
      f('.btn.edit-btn').should be_nil
    elsif params[:user_role]=="teacher"
      f('.btn.edit-btn').should be_displayed
    end
    expect_new_page_load { f('.logout > a').click }
  end


  ##IBM Admin announcement check on their domain  success output
  #

  it "should login as a IBM Admin and and view their course Announcement" do
       course_check_by_admin(:account_name=> "ibm",:user_name=>"ibm@arrivusystems.com",:course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id)
       course_check_by_admin(:account_name=> "ibm",:user_name=>"ibm@arrivusystems.com",:course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id)
       course_check_by_admin(:account_name=> "ibm",:user_name=>"ibm@arrivusystems.com",:course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id)

  end

  #TCS Admin announcement check on their domain

  it "should login as a TCS Admin and and view their course Announcement" do
     course_check_by_admin(:account_name=> "tcs",:user_name=>"tcs@arrivusystems.com",:course_id=>tcs_course1.id,:announcement_id=>tcs_course1_announcement.id)
     course_check_by_admin(:account_name=> "tcs",:user_name=>"tcs@arrivusystems.com",:course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id)
     course_check_by_admin(:account_name=> "tcs",:user_name=>"tcs@arrivusystems.com",:course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id)

  end



  #Admin announcement check on different domain ok tested

  #IBM Admin announcement check on different domain using other courseid
  it "should show an Unauthorized message while IBM admin trying to access the TCS Course's announcement by using tcs course id" do
      course_cross_check_by_admin(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:course_id=>tcs_course1.id,:access_type=>"change course id")
  end

  #Admin announcement check on different domain using other course url
  it "should show Login message when IBM admin tried to accessing TCS course's announcement with TCS url" do
     course_cross_check_by_admin(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:cross_account_name=>"tcs",:course_id=>tcs_course1.id,:access_type=>"change url")
  end

  #TCS Admin announcement check on different domain using other courseid
  it "should show an Unauthorized page while TCS admin trying to access the IBM Course's announcement using TCS course id" do
     course_cross_check_by_admin(:account_name=>"tcs",:user_name=>"tcs@arrivusystems.com",:course_id=>ibm_course1.id,:access_type=>"change course id")
  end

  #Admin announcement check on different domain using other course url
  it "should show Login message when TCS admin tried to accessing IBM domain's course with TCS url" do
     course_cross_check_by_admin(:account_name=>"tcs",:user_name=>"tcs@arrivusystems.com",:cross_account_name=>"ibm",:course_id=>ibm_course1.id,:access_type=>"change url")
  end



  # IBM student Announcement check on their allocated course announcement
  it "should login as IBM Student1 and check their course's announcement" do
  course_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",
                        :course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id,:user_role=>"student")

  course_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",
                         :course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id,:user_role=>"student")

  end

  it "should login as IBM Student2 and check their courses's announcement" do
     course_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",
                        :course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id,:user_role=>"student")

     course_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",
                         :course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id,:user_role=>"student")

  end

  it "should login as IBM Student3 and check their courses's announcement" do
     course_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",
                        :course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id,:user_role=>"student")

     course_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",
                          :course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id,:user_role=>"student")

  end


  # TCS student Announcement check on their allocated course announcement
  it "should login as TCS Student1 and check their courses's announcement" do
     course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st1@arrivusystems.com",
                          :course_id=>tcs_course1.id,:announcement_id=>tcs_course1_announcement.id,:user_role=>"student")

     course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st1@arrivusystems.com",
                          :course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id,:user_role=>"student")

  end

  it "should login as TCS Student2 and check their courses's announcement" do
     course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st2@arrivusystems.com",
                          :course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id,:user_role=>"student")

     course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st2@arrivusystems.com",
                          :course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id,:user_role=>"student")

  end

  it "should login as TCS Student3 and check their courses's announcement" do
     course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st3@arrivusystems.com",
                          :course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id,:user_role=>"student")

     course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st3@arrivusystems.com",
                          :course_id=>tcs_course1.id,:announcement_id=>tcs_course1_announcement.id,:user_role=>"student")

  end




  ## IBM Student trying to view another course announcement  on the same domain

  it "should show unauthorized message when IBM Student1 trying to access another course announcements using another courseid" do
     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",
                                :course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id,:access_type=>"change course id")


  end

  it "should show unauthorized message when IBM Student2 trying to access another course announcement  using another courseid" do
  course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",
                                :course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id,:access_type=>"change course id")
  end


  it "should show unauthorized message when IBM Student3 trying to access another course announcement using another courseid" do
     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",
                                :course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id,:access_type=>"change course id")
  end


  # Student cross testing
  # IBM Student trying to view another  course announcement on another domain  using url

  it "should show login message when IBM Student1 trying to access TCS course's announcements by changing URL" do
     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",:course_id=>tcs_course1.id,
                                :announcement_id=>tcs_course1_announcement.id,:access_type=>"change course url",:cross_account_name=>"tcs")

     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",
                                :course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"tcs")

     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",
                                :course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"tcs")


  end

    it "should show login message when IBM Student2 trying to access TCS course's announcements by changing URL" do
     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",
                                 :course_id=>tcs_course1.id,:announcement_id=>tcs_course1_announcement.id,
                                 :access_type=>"change course url",
                                 :cross_account_name=>"tcs")

     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",
                                :course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"tcs")

     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",
                                :course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"tcs")
  end

  it "should show login message when IBM Student3 trying to access TCS course's announcements by changing URL" do
     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",
                                :course_id=>tcs_course1.id,:announcement_id=>tcs_course1_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"tcs")

     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",
                                :course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"tcs")

     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",
                                :course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"tcs")
  end


  #by changing course id

  it "should show unauthorized message when IBM Student1 trying to access TCS course's announcements by changing course id" do
    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",
                               :course_id=>tcs_course1.id,:announcement_id=>tcs_course1_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",
                               :course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",
                               :course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id,
                               :access_type=>"change course id")


  end

  it "should show unauthorized message when IBM Student2 trying to access TCS course's announcements by changing course id" do
    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",
                               :course_id=>tcs_course1.id,:announcement_id=>tcs_course1_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",
                               :course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",
                               :course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id,
                               :access_type=>"change course id")
  end

  it "should show unauthorized message when IBM Student3 trying to access TCS course's announcements by changing course id" do
    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",
                               :course_id=>tcs_course1.id,:announcement_id=>tcs_course1_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",
                               :course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",
                               :course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id,
                               :access_type=>"change course id")
  end





  # TCS Student trying to view another course announcement which not created by him on the same domain

  it "should show unauthorized message when TCS Student1 trying to access another course announcement using another courseid" do
     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st1@arrivusystems.com",
                                :course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id,:access_type=>"change course id")


  end

  it "should show unauthorized message when TCS Student2 trying to access another course announcement using another courseid" do
  course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st2@arrivusystems.com",
                                :course_id=>tcs_course1.id,:announcement_id=>tcs_course1_announcement.id,:access_type=>"change course id")
  end


  it "should show unauthorized message when TCS Student3 trying to access another course announcement using another courseid" do
     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st3@arrivusystems.com",
                                :course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id,:access_type=>"change course id")
  end


  # TCS Student trying to view another  course announcement of another domain  using url

  it "should show login message when TCS Student1 trying to access IBM course's announcements by changing URL" do
     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st1@arrivusystems.com",
                                :course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"ibm")

     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st1@arrivusystems.com",
                                :course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"ibm")

     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st1@arrivusystems.com",
                                :course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"ibm")


  end

  it "should show login message when TCS Student2 trying to access IBM course's announcements by changing URL" do
     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st2@arrivusystems.com",
                                 :course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id,
                                 :access_type=>"change course url",
                                 :cross_account_name=>"ibm")

     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st2@arrivusystems.com",
                                :course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"ibm")

     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st2@arrivusystems.com",
                                :course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"ibm")
  end


  it "should show login message when TCS Student3 trying to access IBM course's announcements by changing URL" do
     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st3@arrivusystems.com",
                                :course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"ibm")

     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st3@arrivusystems.com",
                                :course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"ibm")

     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st3@arrivusystems.com",
                                :course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"ibm")
  end

###By changing course id

  it "should show unauthorized message when TCS Student1 trying to access IBM course's announcements by changing course id" do
    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st1@arrivusystems.com",
                               :course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st1@arrivusystems.com",
                               :course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st1@arrivusystems.com",
                               :course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id,
                               :access_type=>"change course id")


  end

  it "should show unauthorized message when TCS Student2 trying to access IBM course's announcements by changing course id" do
    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st2@arrivusystems.com",
                               :course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st2@arrivusystems.com",
                               :course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st2@arrivusystems.com",
                               :course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id,
                               :access_type=>"change course id")
  end

  it "should show unauthorized message when TCS Student3 trying to access IBM course's announcements by changing course id" do
    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st3@arrivusystems.com",
                               :course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st3@arrivusystems.com",
                               :course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st3@arrivusystems.com",
                               :course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id,
                               :access_type=>"change course id")
  end



  #IBM Teacher can view their announcement of their own course

  it "should login as a IBM teacher1 in ibm account and view their announcement " do

     course_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",
                          :course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id,:user_role=>"teacher")

  end
  it "should login as a IBM teacher2 in ibm account and view their announcement " do

     course_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",
                          :course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id,:user_role=>"teacher")

  end
  it "should login as a IBM teacher3 in ibm account and view their announcement " do

     course_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",
                          :course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id,:user_role=>"teacher")

  end

  #TCS Teacher can view their announcement of their own course

  it "should login as a TCS teacher1 in tcs account and view their announcement " do

     course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",
                          :course_id=>tcs_course1.id,:announcement_id=>tcs_course1_announcement.id,:user_role=>"teacher")

  end
  it "should login as a TCS teacher2 in tcs account and view their announcement " do

     course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr2@arrivusystems.com",
                          :course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id,:user_role=>"teacher")

  end
  it "should login as a TCS teacher3 in tcs account and view their announcement " do

     course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr3@arrivusystems.com",
                          :course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id,:user_role=>"teacher")

  end






  ##IBM Teacher trying to view another course announcement which not created by him on the same domain

  it "should show unauthorized message when IBM Teacher1 trying to access other courses announcement which was not created by him using other courseid" do
     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",
                                :course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id,
                                :access_type=>"change course id")


  end

  it "should show unauthorized message when IBM Teacher2 trying to access other courses announcement which was not created by him using other courseid" do
  course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",
                                :course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id,
                                :access_type=>"change course id")
  end


  it "should show unauthorized message when IBM Teacher3 trying to access other courses announcement which was not created by him using other courseid" do
     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",
                                :course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id,
                                :access_type=>"change course id")
  end


  ##IBM Teacher trying to view another  course announcement which not created by him on another domain  using url

  it "should show login message when IBM Teacher1 trying to access TCS courses announcement on TCS domain by using TCS course URL" do
     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",
                                :course_id=>tcs_course1.id,:announcement_id=>tcs_course1_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"tcs")

     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",
                                :course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"tcs")

     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",
                                :course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"tcs")


  end

  it "should show login message when IBM Teacher2 trying to access TCS courses announcement on TCS domain by using TCS course URL" do
     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",
                                 :course_id=>tcs_course1.id,:announcement_id=>tcs_course1_announcement.id,
                                 :access_type=>"change course url",
                                 :cross_account_name=>"tcs")

     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",
                                :course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"tcs")

     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",
                                :course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"tcs")
  end


  it "should show login message when IBM Teacher3 trying to access TCS courses announcement on TCS domain by using TCS course URL" do
     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",
                                :course_id=>tcs_course1.id,:announcement_id=>tcs_course1_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"tcs")

     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",
                                :course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"tcs")

     course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",
                                :course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"tcs")
  end

  ###by changing course id


  it "should show login message when IBM Teacher1 trying to access TCS courses announcement on TCS domain by using TCS course id" do
    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",
                               :course_id=>tcs_course1.id,:announcement_id=>tcs_course1_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",
                               :course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",
                               :course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id,
                               :access_type=>"change course id")


  end

  it "should show login message when IBM Teacher2 trying to access TCS courses announcement on TCS domain by using TCS course id" do
    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",
                               :course_id=>tcs_course1.id,:announcement_id=>tcs_course1_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",
                               :course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",
                               :course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id,
                               :access_type=>"change course id")
  end


  it "should show login message when IBM Teacher3 trying to access TCS courses announcement on TCS domain by using TCS course URL" do
    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",
                               :course_id=>tcs_course1.id,:announcement_id=>tcs_course1_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",
                               :course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",
                               :course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id,
                               :access_type=>"change course id")
  end






  ##TCS Teacher trying to view another course announcement which not created by him on the same domain
      #failed tests


  it "should show unauthorized message when TCS Teacher1 trying to access another course announcement which was not created by him using another courseid" do
     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",
                                :course_id=>tcs_course3.id,:announcement_id=>tcs_course3_announcement.id,:access_type=>"change course id")


  end

  it "should show unauthorized message when TCS Teacher2 trying to access another course announcement which was not created by him using another courseid" do
  course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr2@arrivusystems.com",
                                :course_id=>tcs_course1.id,:announcement_id=>tcs_course1_announcement.id,:access_type=>"change course id")
  end


  it "should show unauthorized message when TCS Teacher3 trying to access another course announcement which was not created by him using another courseid" do
     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr3@arrivusystems.com",
                                :course_id=>tcs_course2.id,:announcement_id=>tcs_course2_announcement.id,:access_type=>"change course id")
  end


  ##TCS Teacher trying to view another  course announcement which not created by him on another domain  using url

it "should show login message when TCS Teacher1 trying to access IBM course's announcements by changing URL" do
     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",
                                :course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"ibm")

     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",
                                :course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"ibm")

     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",
                                :course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"ibm")


end

it "should show login message when TCS Teacher2 trying to access IBM course's announcements by changing URL" do
     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr2@arrivusystems.com",
                                 :course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id,
                                 :access_type=>"change course url",
                                 :cross_account_name=>"ibm")

     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr2@arrivusystems.com",
                                :course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"ibm")

     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr2@arrivusystems.com",
                                :course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"ibm")
end


it "should show login message when TCS Teacher3 trying to access IBM course's announcements by changing URL" do
     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr3@arrivusystems.com",
                                :course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"ibm")

     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr3@arrivusystems.com",
                                :course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"ibm")

     course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr3@arrivusystems.com",
                                :course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id,
                                :access_type=>"change course url",
                                :cross_account_name=>"ibm")
end


##### By changing course id

  it "should show login message when TCS Teacher1 trying to access IBM courses announcement on IBM domain by using IBM course id" do
    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",
                               :course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",
                               :course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",
                               :course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id,
                               :access_type=>"change course id")


  end

  it "should show login message when TCS Teacher2 trying to access IBM courses announcement on IBM domain by using IBM course id" do
    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr2@arrivusystems.com",
                               :course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr2@arrivusystems.com",
                               :course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr2@arrivusystems.com",
                               :course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id,
                               :access_type=>"change course id")
  end


  it "should show login message when TCS Teacher3 trying to access IBM courses announcement on IBM domain by using IBM course URL" do
    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr3@arrivusystems.com",
                               :course_id=>ibm_course1.id,:announcement_id=>ibm_course1_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr3@arrivusystems.com",
                               :course_id=>ibm_course2.id,:announcement_id=>ibm_course2_announcement.id,
                               :access_type=>"change course id")

    course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr3@arrivusystems.com",
                               :course_id=>ibm_course3.id,:announcement_id=>ibm_course3_announcement.id,
                               :access_type=>"change course id")
  end



## #Teacher as a student course check in the same domain
# ##IBM Teacher as a student course check in the same domain

it "should show the Announcement page without editing options when a teacher1 enrolled as a student in other courses of same domain" do
    teacher_as_a_student(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",
                         :course_id=>ibm_course4.id,:announcement_id=>ibm_course4_announcement.id,:user_role=>"student")

end




#TCS Teacher as a student course check in the same domain

it "should show the Announcement page without editing options when a teacher1 enrolled as a student in other courses of same domain" do
     teacher_as_a_student(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",
                          :course_id=>tcs_course4.id,:announcement_id=>tcs_course4_announcement.id,:user_role=>"student")

end



##  Teacher as a student course check in the different domain
## IBM Teacher accessing as a student of course in another domain

it "should show the Announcement page without editing options when a teacher1 enrolled as a student in other courses of different domain" do
     teacher_as_a_student(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",
                          :course_id=>tcs_course4.id,:announcement_id=>tcs_course4_announcement.id,:user_role=>"student")

end


### TCS Teacher accessing as a student of course in another domain
it "should show the Announcement page without editing options when a teacher1 enrolled as a student in other courses of different domain" do
     teacher_as_a_student(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",
                          :course_id=>ibm_course4.id,:announcement_id=>ibm_course4_announcement.id,:user_role=>"student")

end


end





  
  

   


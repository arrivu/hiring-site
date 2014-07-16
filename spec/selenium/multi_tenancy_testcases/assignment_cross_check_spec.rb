require File.expand_path(File.dirname(__FILE__) + '/common_mt')
require File.expand_path(File.dirname(__FILE__) + '/data_setup')


describe "Assignment_Cross_Check_Creation" do

  it_should_behave_like "in-process server selenium tests"



  def assignment_check_by_admin(params={})
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form(params[:user_name],"Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == params[:user_name]
    params[:assignment_ids]. each do |assignment_id|
      course_id=Assignment.find(assignment_id).context_id
      driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course_id}/assignments"
      f('#breadcrumbs').text.should include 'Assignments'
      f("#assignment_#{assignment_id}").should be_displayed
      driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course_id}/assignments/#{assignment_id}"
      f('#assignment_show').should be_displayed
      f('.icon-edit').should be_displayed
    end
    expect_new_page_load { f('.logout > a').click }
  end

  def assignment_cross_check_admin(params={})
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form(params[:user_name],"Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == params[:user_name]
    params[:assignment_ids].each do |assignment_id|
      course_id=Assignment.find(assignment_id).context_id
      if params[:access_type]=="change course id"
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course_id}/assignments/#{params[:assignment_id]}"
        driver.find_element(:id,"unauthorized_holder").should be_displayed
        driver.find_element(:id,"unauthorized_message").should be_displayed
        f('.ui-state-error').should include_text("Unauthorized")
      end
      if params[:access_type]=="change url"
        driver.get "http://#{params[:cross_account_name]}.lvh.me:#{$server_port}/courses/#{course_id}/assignments/#{params[:assignment_id]}"
        driver.find_element(:id,"login_form").should be_displayed
        f('.ui-state-error').should include_text("Please Log In")
        driver.find_element(:id,"pseudonym_session_unique_id").should be_displayed
        driver.find_element(:id,"pseudonym_session_password").should be_displayed
      end
    end
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    expect_new_page_load { f('.logout > a').click }
  end

  def assignment_check_by_student(params={})
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form(params[:user_name],"Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == params[:user_name]
    params[:assignment_ids]. each do |assignment_id|
      course_id=Assignment.find(assignment_id).context_id
      assignment_title= Assignment.find(assignment_id).title
      driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course_id}/assignments"
      f("#assignments_for_student").should be_displayed  #it may be wrong
      f("#assignment_#{assignment_id}").should be_displayed
      f('.title').text.should == assignment_title
      expect_new_page_load { driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course_id}/assignments/#{assignment_id}"}
      f('#assignment_show').should be_displayed
      f('.title').text.should == assignment_title
    end
    expect_new_page_load { f('.logout > a').click }
  end


    ##IBM admin checking their own assignment topics

  it "should allow IBM Admin to view the all assignments in IBM domain" do

    assignment_check_by_admin(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:assignment_ids=>[ibm_course1_assignment.id,ibm_course2_assignment.id,ibm_course3_assignment.id])

  end


  #TCS admin checking their own assignment topics

  it "should allow TCS Admin to view the all assignments in TCS domain" do

    assignment_check_by_admin(:account_name=>"tcs",:user_name=>"tcs@arrivusystems.com",:assignment_ids=>[tcs_course1_assignment.id,tcs_course2_assignment.id,tcs_course3_assignment.id])
  end

#  IBM Admin tries to check the assignments of another domain

  it "should show a Unauthorized Message when IBM admin tries to view the assignments of TCS domain by using TCS course id" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:course_id=>tcs_course1.id,:access_type=>"change course id",:assignment_ids=>[tcs_course1_assignment.id,tcs_course2_assignment.id,tcs_course3_assignment.id])
  end

  it "should show a login page when IBM admin tries to view the assignments of TCS domain by using tcs course url" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:course_id=>tcs_course1.id,:cross_account_name=>"tcs",:access_type=>"change course url",:assignment_ids=>[tcs_course1_assignment.id,tcs_course2_assignment.id,tcs_course3_assignment.id])
  end

  ## TCS Admin tries to check the assignments of ibm assignments

  it "should show a Unauthorized Message when IBM admin tries to view the assignments of TCS domain by using TCS course id" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs@arrivusystems.com",:course_id=>ibm_course1.id,:access_type=>"change course id",:assignment_ids=>[ibm_course1_assignment.id,ibm_course2_assignment.id,ibm_course3_assignment.id])
  end

  it "should show a login page when IBM admin tries to view the assignments of TCS domain by using TCS course url" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs@arrivusystems.com",:course_id=>ibm_course1.id,:cross_account_name=>"ibm",:access_type=>"change course url",:assignment_ids=>[ibm_course1_assignment.id,ibm_course2_assignment.id,ibm_course3_assignment.id])
  end

    ##teacher viewing their announcement
    # IBM Teacher going to view the assignments
  it "should allow to view the assignments with editing options when IBM teacher1 tried to access the assignment" do
    assignment_check_by_admin(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",:assignment_ids=>[tcs_course1_assignment.id,tcs_course2_assignment.id])

  end

  it "should allow to view the assignments with editing options when IBM teacher2 tried to access the assignment" do
    assignment_check_by_admin(:account_name=>"tcs",:user_name=>"tcs.tr2@arrivusystems.com",:assignment_ids=>[tcs_course2_assignment.id,tcs_course3_assignment.id])

  end

  it "should allow to view the assignments with editing options when IBM teacher3 tried to access the assignment" do
    assignment_check_by_admin(:account_name=>"tcs",:user_name=>"tcs.tr3@arrivusystems.com",:assignment_ids=>[tcs_course3_assignment.id,tcs_course1_assignment.id])

  end

  # TCS Teacher going to view the assignments
  it "should allow to view the assignments with editing options when TCS teacher1 tried to access the assignment" do
    assignment_check_by_admin(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",:assignment_ids=>[ibm_course1_assignment.id,ibm_course2_assignment.id])

  end

  it "should allow to view the assignments with editing options when TCS teacher2 tried to access the assignment" do
    assignment_check_by_admin(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",:assignment_ids=>[ibm_course2_assignment.id,ibm_course3_assignment.id])

  end

  it "should allow to view the assignments with editing options when TCS teacher3 tried to access the assignment" do
    assignment_check_by_admin(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",:assignment_ids=>[ibm_course3_assignment.id,ibm_course1_assignment.id])

  end

  ###cross checking assignments by teachers on same domain

  it "should show unauthorized message when a IBM teacher1 tried to access IBM teacher3's assignments" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",:assignment_ids=>[ibm_course3_assignment.id],:access_type=>"change course id")
  end

  it "should show unauthorized message when a IBM teacher2 tried to access IBM teacher1's assignments" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",:assignment_ids=>[ibm_course1_assignment.id],:access_type=>"change course id")
  end

  it "should show unauthorized message when a IBM teacher3 tried to access IBM teacher2's assignments" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",:assignment_ids=>[ibm_course2_assignment.id],:access_type=>"change course id")
  end


  it "should show unauthorized message when a TCS teacher1 tried to access TCS teacher3's assignments" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",:assignment_ids=>[tcs_course3_assignment.id],:access_type=>"change course id")
  end

  it "should show unauthorized message when a TCS teacher2 tried to access TCS teacher1's assignments" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.tr2@arrivusystems.com",:assignment_ids=>[tcs_course1_assignment.id],:access_type=>"change course id")
  end

  it "should show unauthorized message when a TCS teacher3 tried to access TCS teacher2's assignments" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.tr3@arrivusystems.com",:assignment_ids=>[tcs_course2_assignment.id],:access_type=>"change course id")
  end

  ###cross checking assignments by teachers on different domain by changing assignment id

  it "should show login page when a IBM teacher1 tried to access TCS assignments by changing assignment ID" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",:assignment_ids=>[tcs_course1_assignment.id,tcs_course2_assignment.id,tcs_course3_assignment.id],:access_type=>"change course id")
  end

  it "should show login page when a IBM teacher2 tried to access TCS assignments by changing assignment ID" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",:assignment_ids=>[tcs_course1_assignment.id,tcs_course2_assignment.id,tcs_course3_assignment.id],:access_type=>"change course id")
  end

  it "should show login page when a IBM teacher3 tried to access TCS assignments by changing assignment ID" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",:assignment_ids=>[tcs_course1_assignment.id,tcs_course2_assignment.id,tcs_course3_assignment.id],:access_type=>"change course id")
  end



  it "should show login page when a TCS teacher1 tried to access IBM assignments by changing assignment ID" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",:assignment_ids=>[ibm_course1_assignment.id,ibm_course2_assignment.id,ibm_course3_assignment.id],:access_type=>"change course id")
  end

  it "should show login page when a TCS teacher2 tried to access IBM assignments by changing assignment ID" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.tr2@arrivusystems.com",:assignment_ids=>[ibm_course1_assignment.id,ibm_course2_assignment.id,ibm_course3_assignment.id],:access_type=>"change course id")
  end

  it "should show login page when a TCS teacher3 tried to access IBM assignments by changing assignment ID" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.tr3@arrivusystems.com",:assignment_ids=>[ibm_course1_assignment.id,ibm_course2_assignment.id,ibm_course3_assignment.id],:access_type=>"change course id")
  end

  ###cross checking assignments by teachers on different domain by changing url

  it "should show login page when a IBM teacher1 tried to access TCS assignments by changing assignment URL" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",:cross_account_name=>"tcs",:assignment_ids=>[tcs_course1_assignment.id,tcs_course2_assignment.id,tcs_course3_assignment.id],:access_type=>"change url")
  end

  it "should show login page when a IBM teacher2 tried to access TCS assignments by changing assignment URL" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",:cross_account_name=>"tcs",:assignment_ids=>[tcs_course1_assignment.id,tcs_course2_assignment.id,tcs_course3_assignment.id],:access_type=>"change url")
  end

  it "should show login page when a IBM teacher3 tried to access TCS assignments by changing assignment URL" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",:cross_account_name=>"tcs",:assignment_ids=>[tcs_course1_assignment.id,tcs_course2_assignment.id,tcs_course3_assignment.id],:access_type=>"change url")
  end


  it "should show login page when a TCS teacher1 tried to access IBM assignments by changing assignment URL" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",:cross_account_name=>"ibm",:assignment_ids=>[ibm_course1_assignment.id,ibm_course2_assignment.id,ibm_course3_assignment.id],:access_type=>"change url")
  end

  it "should show login page when a TCS teacher2 tried to access IBM assignments by changing assignment URL" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.tr2@arrivusystems.com",:cross_account_name=>"ibm",:assignment_ids=>[ibm_course1_assignment.id,ibm_course2_assignment.id,ibm_course3_assignment.id],:access_type=>"change url")
  end

  it "should show login page when a TCS teacher3 tried to access IBM assignments by changing assignment URL" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.tr3@arrivusystems.com",:cross_account_name=>"ibm",:assignment_ids=>[ibm_course1_assignment.id,ibm_course2_assignment.id,ibm_course3_assignment.id],:access_type=>"change url")
  end





  #Student viewing their announcement
    # IBM Student viewing to view the assignments
  it "should allow to view the assignments with editing options when IBM Student1 tried to access the assignment" do
    assignment_check_by_student(:account_name=>"tcs",:user_name=>"tcs.st1@arrivusystems.com",:assignment_ids=>[tcs_course1_assignment.id,tcs_course2_assignment.id])

  end

  it "should allow to view the assignments with editing options when IBM Student2 tried to access the assignment" do
    assignment_check_by_student(:account_name=>"tcs",:user_name=>"tcs.st2@arrivusystems.com",:assignment_ids=>[tcs_course2_assignment.id,tcs_course3_assignment.id])

  end

  it "should allow to view the assignments with editing options when IBM Student3 tried to access the assignment" do
    assignment_check_by_student(:account_name=>"tcs",:user_name=>"tcs.st3@arrivusystems.com",:assignment_ids=>[tcs_course3_assignment.id,tcs_course1_assignment.id])

  end

  # TCS Student going to view the assignments
  it "should allow to view the assignments with editing options when TCS Student1 tried to access the assignment" do
    assignment_check_by_student(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",:assignment_ids=>[ibm_course1_assignment.id,ibm_course2_assignment.id])

  end

  it "should allow to view the assignments with editing options when TCS Student2 tried to access the assignment" do
    assignment_check_by_student(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",:assignment_ids=>[ibm_course2_assignment.id,ibm_course3_assignment.id])

  end

  it "should allow to view the assignments with editing options when TCS Student3 tried to access the assignment" do
    assignment_check_by_student(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",:assignment_ids=>[ibm_course3_assignment.id,ibm_course1_assignment.id])

  end



  ###cross checking assignments by Students on same domain

  it "should show unauthorized message when a IBM student1 tried to access IBM Student3's assignments" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",:assignment_ids=>[ibm_course3_assignment.id],:access_type=>"change course id")
  end

  it "should show unauthorized message when a IBM student2 tried to access IBM student1's assignments" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",:assignment_ids=>[ibm_course1_assignment.id],:access_type=>"change course id")
  end

  it "should show unauthorized message when a IBM student3 tried to access IBM student2's assignments" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",:assignment_ids=>[ibm_course2_assignment.id],:access_type=>"change course id")
  end


  it "should show unauthorized message when a TCS student1 tried to access TCS student3's assignments" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.st1@arrivusystems.com",:assignment_ids=>[tcs_course3_assignment.id],:access_type=>"change course id")
  end

  it "should show unauthorized message when a TCS student2 tried to access TCS student's assignments" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.st2@arrivusystems.com",:assignment_ids=>[tcs_course1_assignment.id],:access_type=>"change course id")
  end

  it "should show unauthorized message when a TCS student3 tried to access TCS student2's assignments" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.st3@arrivusystems.com",:assignment_ids=>[tcs_course2_assignment.id],:access_type=>"change course id")
  end

  ####cross checking assignments by teachers on different domain by changing assignment id

  it "should show login page when a IBM student1 tried to access TCS assignments by changing assignment ID" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",:assignment_ids=>[tcs_course1_assignment.id,tcs_course2_assignment.id,tcs_course3_assignment.id],:access_type=>"change course id")
  end

  it "should show login page when a IBM student2 tried to access TCS assignments by changing assignment ID" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",:assignment_ids=>[tcs_course1_assignment.id,tcs_course2_assignment.id,tcs_course3_assignment.id],:access_type=>"change course id")
  end

  it "should show login page when a IBM student3 tried to access TCS assignments by changing assignment ID" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",:assignment_ids=>[tcs_course1_assignment.id,tcs_course2_assignment.id,tcs_course3_assignment.id],:access_type=>"change course id")
  end

  it "should show login page when a TCS student1 tried to access IBM assignments by changing assignment ID" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.st1@arrivusystems.com",:assignment_ids=>[ibm_course1_assignment.id,ibm_course2_assignment.id,ibm_course3_assignment.id],:access_type=>"change course id")
  end

  it "should show login page when a TCS student2 tried to access IBM assignments by changing assignment ID" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.st2@arrivusystems.com",:assignment_ids=>[ibm_course1_assignment.id,ibm_course2_assignment.id,ibm_course3_assignment.id],:access_type=>"change course id")
  end

  it "should show login page when a TCS student3 tried to access IBM assignments by changing assignment ID" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.st3@arrivusystems.com",:assignment_ids=>[ibm_course1_assignment.id,ibm_course2_assignment.id,ibm_course3_assignment.id],:access_type=>"change course id")
  end

  ###cross checking assignments by students on different domain by changing url

  it "should show login page when a IBM student1 tried to access TCS assignments by changing assignment URL" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",:cross_account_name=>"tcs",:assignment_ids=>[tcs_course1_assignment.id,tcs_course2_assignment.id,tcs_course3_assignment.id],:access_type=>"change url")
  end

  it "should show login page when a IBM student2 tried to access TCS assignments by changing assignment URL" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",:cross_account_name=>"tcs",:assignment_ids=>[tcs_course1_assignment.id,tcs_course2_assignment.id,tcs_course3_assignment.id],:access_type=>"change url")
  end

  it "should show login page when a IBM student3 tried to access TCS assignments by changing assignment URL" do
    assignment_cross_check_admin(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",:cross_account_name=>"tcs",:assignment_ids=>[tcs_course1_assignment.id,tcs_course2_assignment.id,tcs_course3_assignment.id],:access_type=>"change url")
  end


  it "should show login page when a TCS student1 tried to access IBM assignments by changing assignment URL" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.st1@arrivusystems.com",:cross_account_name=>"ibm",:assignment_ids=>[ibm_course1_assignment.id,ibm_course2_assignment.id,ibm_course3_assignment.id],:access_type=>"change url")
  end

  it "should show login page when a TCS student2 tried to access IBM assignments by changing assignment URL" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.st2@arrivusystems.com",:cross_account_name=>"ibm",:assignment_ids=>[ibm_course1_assignment.id,ibm_course2_assignment.id,ibm_course3_assignment.id],:access_type=>"change url")
  end

  it "should show login page when a TCS student3 tried to access IBM assignments by changing assignment URL" do
    assignment_cross_check_admin(:account_name=>"tcs",:user_name=>"tcs.st3@arrivusystems.com",:cross_account_name=>"ibm",:assignment_ids=>[ibm_course1_assignment.id,ibm_course2_assignment.id,ibm_course3_assignment.id],:access_type=>"change url")
  end




  ####TCS Teacher as a student course check in the same domain

  it "should login as student IBM teacher1 enrolled as a student in other courses of same domain" do
    assignment_check_by_student(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",:assignment_ids=>[ibm_course4_assignment.id])
  end

  it "should login as student IBM teacher1 enrolled as a student in other courses of same domain" do
    assignment_check_by_student(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",:assignment_ids=>[tcs_course4_assignment.id])
  end

  it "should login as student IBM teacher1 enrolled as a student in other courses of same domain" do
    assignment_check_by_student(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",:assignment_ids=>[tcs_course4_assignment.id])
  end

  it "should login as student IBM teacher1 enrolled as a student in other courses of same domain" do
    assignment_check_by_student(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",:assignment_ids=>[ibm_course4_assignment.id])
  end




end
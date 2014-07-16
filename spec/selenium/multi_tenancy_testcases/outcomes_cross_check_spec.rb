require File.expand_path(File.dirname(__FILE__) + '/common_mt')
require File.expand_path(File.dirname(__FILE__) + '/data_setup')

describe "outcomes_Cross_Check_Creation" do

  it_should_behave_like "in-process server selenium tests"


  def view_account_level_outcome(params={})
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form(params[:user_name],"Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == params[:user_name]
    params[:outcomes].each do |outcome|
      account=nil
      course=nil
      if params[:outcome_level]=="account level"
        account=Account.find(outcome.context_id)
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/accounts/#{account.id}/outcomes"
        f("#section-tabs-header").text.should include_text account.name
      else
        course=Course.find(outcome.context_id)
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course.id}/outcomes"
        f("#section-tabs-header").text.should include_text course.course_code
      end
      wait_for_ajaximations

      f("#content").text.should include_text "Learning Outcomes"
      if params[:user_role]!="student"
        fj(".ui-button-text").text.should include_text "New Outcome"
        f('.find_outcome').should be_displayed
        f('.add_outcome_link').should be_displayed
      end
        fj(".outcomes-sidebar").text.should include_text outcome.short_description
        f(".ellipsis[title='#{outcome.short_description}']").click
        wait_for_ajaximations
        fj(".outcomes-content").text.should include_text outcome.short_description
      if params[:user_role]!="student"
        f('.edit_button').should be_displayed
        f('.delete_button').should be_displayed
      else
        f('.edit_button').should be_nil
        f('.delete_button').should be_nil
      end

      wait_for_ajaximations
      f(".outcomes-content .title").text.should == outcome.short_description
      if params[:outcome_level]=="account level"
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/accounts/#{account.id}/outcomes/#{outcome.id}"
      else
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course.id}/outcomes/#{outcome.id}"
      end
      wait_for_ajaximations

      if params[:user_role]!="student"
        fj("a:contains(' Back to Outcomes')").should be_displayed
        f("#content").text.should include_text "Aligned Items"
        f("#content").text.should include_text "Outcome Artifacts"
      else
        unauthorized_warning_message
      end

    end
    expect_new_page_load { f('.logout > a').click }
  end

  def outcome_corss_check(params={})
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form(params[:user_name],"Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == params[:user_name]
    params[:outcomes].each do |outcome|
      if params[:outcome_level]=="account level"
        account=Account.find(outcome.context_id)
        if params[:access_type]=="change account id"
          driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/accounts/#{account.id}/outcomes"
          unauthorized_warning_message
          driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
          wait_for_ajaximations
          driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/accounts/#{account.id}/outcomes/#{outcome.id}"
          unauthorized_warning_message
        else
          driver.get "http://#{params[:checking_account_name]}.lvh.me:#{$server_port}/accounts/#{account.id}/outcomes"
          login_warning_message
          driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
          wait_for_ajaximations
          driver.get "http://#{params[:checking_account_name]}.lvh.me:#{$server_port}/accounts/#{account.id}/outcomes/#{outcome.id}"
          login_warning_message
        end
      else
        course=Course.find(outcome.context_id)
        if params[:access_type]=="change account id"
          driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course.id}/outcomes"
          unauthorized_warning_message
          driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
          wait_for_ajaximations
          driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course.id}/outcomes/#{outcome.id}"
          unauthorized_warning_message
        else
          driver.get "http://#{params[:checking_account_name]}.lvh.me:#{$server_port}/courses/#{course.id}/outcomes"
          login_warning_message
          driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
          wait_for_ajaximations
          driver.get "http://#{params[:checking_account_name]}.lvh.me:#{$server_port}/courses/#{course.id}/outcomes/#{outcome.id}"
          login_warning_message
        end
      end
    end
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    wait_for_ajaximations
    expect_new_page_load { f('.logout > a').click }
  end

  def admin_outcome_access_by_users(params={})
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    params[:users].each do |users|
      fill_in_login_form(users.name,"Admin123$")
      wait_for_ajaximations
      if params[:access_type]=="change account id"
        f('.user_name').text.should == users.name
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/accounts/#{params[:checking_account_id]}/outcomes"
        unauthorized_warning_message
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
        wait_for_ajaximations
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/accounts/#{params[:checking_account_id]}/outcomes/#{params[:outcome_id]}"
        unauthorized_warning_message
      else
        driver.get "http://#{params[:checking_account_name]}.lvh.me:#{$server_port}/accounts/#{params[:checking_account_id]}/outcomes"
        login_warning_message
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
        wait_for_ajaximations
        driver.get "http://#{params[:checking_account_name]}.lvh.me:#{$server_port}/accounts/#{params[:checking_account_id]}/outcomes/#{params[:outcome_id]}"
        login_warning_message
      end
      driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
      expect_new_page_load { f('.logout > a').click }
    end
  end



  ##############  Account Level Outcomes ##########################

  #### IBM Admin viewing account level outcomes in IBM domain
  it "should show the Outcomes with editing options when IBM admin try to access IBM account level outcome" do
    view_account_level_outcome(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:outcomes=>[ibm_account_level_outcome],:outcome_level=>"account level")
  end
  ##### TCS Admin viewing account level outcomes in TCS domain
  it "should show the Outcomes with editing options when TCS admin try to access TCS account level outcome" do
    view_account_level_outcome(:account_name=>"tcs",:user_name=>"tcs@arrivusystems.com",:outcomes=>[tcs_account_level_outcome],:outcome_level=>"account level")
  end



  ##### Account level outcome cross check by admin by changing account id
  it "should show unauthorized message when IBM admin try to access TCS account's account level outcome by changing account id" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:outcomes=>[tcs_account_level_outcome],
                        :outcome_level=>"account level",:access_type=>"change account id")
  end

  it "should show unauthorized message when TCS admin try to access IBM account's account level outcome  by changing account id" do
    outcome_corss_check(:account_name=>"tcs",:user_name=>"tcs@arrivusystems.com",:outcomes=>[ibm_account_level_outcome],
                        :outcome_level=>"account level",:access_type=>"change account id")
  end


  ##### Account level outcome cross check by admin by changing whole url
  it "should show login page with warning message when IBM admin try to access TCS account's account level outcome by changing whole url" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:outcomes=>[tcs_account_level_outcome],
                        :checking_account_name=>"tcs",:outcome_level=>"account level",:access_type=>"change url")
  end

  it "should show login page with warning message when TCS admin try to access IBM account's account level outcome by changing whole url" do
    outcome_corss_check(:account_name=>"tcs",:user_name=>"tcs@arrivusystems.com",:outcomes=>[ibm_account_level_outcome],
                        :checking_account_name=>"ibm",:outcome_level=>"account level",:access_type=>"change url")
  end

  #### Teacher going to view account level outcome

  it "should show unauthorized message when IBM teachers going to access Account level outcomes" do
    admin_outcome_access_by_users(:account_name=>"ibm",:checking_account_id=>ibm_account.id,:access_type=>"change account id",
                                  :users=>[ibm_teacher1,ibm_teacher2,ibm_teacher3,ibm_teacher4],:outcome_id=>ibm_account_level_outcome.id)
  end

  it "should show unauthorized message when TCS teachers going to access Account level outcomes" do
    admin_outcome_access_by_users(:account_name=>"tcs",:checking_account_id=>tcs_account.id,:access_type=>"change account id",
                                  :users=>[tcs_teacher1,tcs_teacher2,tcs_teacher3,tcs_teacher4],:outcome_id=>tcs_account_level_outcome.id)
  end

  ##### cross check by changing account id

  it "should show unauthorized message when IBM teachers going to access TCS Account level outcomes by changing account id" do
    admin_outcome_access_by_users(:account_name=>"ibm",:checking_account_id=>tcs_account.id,:access_type=>"change account id",
                                  :users=>[ibm_teacher1,ibm_teacher2,ibm_teacher3,ibm_teacher4],:outcome_id=>tcs_account_level_outcome.id)
  end

  it "should show unauthorized message when TCS teachers going to access IBM Account level outcomes by changing account id" do
    admin_outcome_access_by_users(:account_name=>"tcs",:checking_account_id=>ibm_account.id,:access_type=>"change account id",
                                  :users=>[tcs_teacher1,tcs_teacher2,tcs_teacher3,tcs_teacher4],:outcome_id=>ibm_account_level_outcome.id)
  end

  ### cross check by changing whold url
  it "should show login page with warning message when IBM teachers going to access TCS Account level outcomes by changing whole url" do
    admin_outcome_access_by_users(:account_name=>"ibm",:checking_account_id=>tcs_account.id,:access_type=>"change url",:checking_account_name=>"tcs",
                                  :users=>[ibm_teacher1,ibm_teacher2,ibm_teacher3,ibm_teacher4],:outcome_id=>tcs_account_level_outcome.id)
  end

  it "should show login page with warning message when TCS teachers going to access IBM Account level outcomes by changing whole url" do
    admin_outcome_access_by_users(:account_name=>"tcs",:checking_account_id=>ibm_account.id,:access_type=>"change url",:checking_account_name=>"ibm",
                                  :users=>[tcs_teacher1,tcs_teacher2,tcs_teacher3,tcs_teacher4],:outcome_id=>ibm_account_level_outcome.id)
  end

  #### student going to view account level outcome

  it "should show unauthorized message when IBM students going to access Account level outcomes" do
    admin_outcome_access_by_users(:account_name=>"ibm",:checking_account_id=>ibm_account.id,:access_type=>"change account id",
                                  :users=>[ibm_student1,ibm_student2,ibm_student3,ibm_student4],:outcome_id=>ibm_account_level_outcome.id)
  end

  it "should show unauthorized message when TCS students going to access Account level outcomes" do
    admin_outcome_access_by_users(:account_name=>"tcs",:checking_account_id=>tcs_account.id,:access_type=>"change account id",
                                  :users=>[tcs_student1,tcs_student2,tcs_student3,tcs_student4],:outcome_id=>tcs_account_level_outcome.id)
  end

  ### cross check by changing account id

  it "should show unauthorized message when IBM students going to access TCS Account level outcomes by changing account id" do
    admin_outcome_access_by_users(:account_name=>"ibm",:checking_account_id=>tcs_account.id,:access_type=>"change account id",
                                  :users=>[ibm_student1,ibm_student2,ibm_student3,ibm_student4],:outcome_id=>tcs_account_level_outcome.id)
  end

  it "should show unauthorized message when TCS students going to access IBM Account level outcomes by changing account id" do
    admin_outcome_access_by_users(:account_name=>"tcs",:checking_account_id=>ibm_account.id,:access_type=>"change account id",
                                  :users=>[tcs_student1,tcs_student2,tcs_student3,tcs_student4],:outcome_id=>ibm_account_level_outcome.id)
  end

  ### cross check by changing whold url
  it "should show login page with warning message when IBM students going to access TCS Account level outcomes by changing whole url" do
    admin_outcome_access_by_users(:account_name=>"ibm",:checking_account_id=>tcs_account.id,:access_type=>"change url",:checking_account_name=>"tcs",
                                  :users=>[ibm_student1,ibm_student2,ibm_student3,ibm_student4],:outcome_id=>tcs_account_level_outcome.id)
  end

  it "should show login page with warning message when TCS students going to access IBM Account level outcomes by changing whole url" do
    admin_outcome_access_by_users(:account_name=>"tcs",:checking_account_id=>ibm_account.id,:access_type=>"change url",:checking_account_name=>"ibm",
                                  :users=>[tcs_student1,tcs_student2,tcs_student3,tcs_student4],:outcome_id=>ibm_account_level_outcome.id)
  end





  ################# Coruse Level Outcomes  ############################

  #### IBM Admin viewing course level outcomes in IBM domain
  it "should show the Outcomes with editing options when IBM admin try to access IBM Course level Outcomes" do
    view_account_level_outcome(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:outcomes=>[ibm_course1_outcome,ibm_course2_outcome,ibm_course3_outcome,ibm_course4_outcome],:outcome_level=>"course level")
  end
  #### TCS Admin viewing course level outcomes in TCS domain
  it "should show the Outcomes with editing options when TCS admin try to access TCS Course level Outcomes" do
    view_account_level_outcome(:account_name=>"tcs",:user_name=>"tcs@arrivusystems.com",:outcomes=>[tcs_course1_outcome,tcs_course2_outcome,tcs_course3_outcome,tcs_course4_outcome],:outcome_level=>"course level")
  end

  ##### course level out come cross check by admin

  it "should show unauthorized message when IBM admin try to access TCS account's course level outcome by changing account id" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:outcomes=>[tcs_course1_outcome,tcs_course2_outcome,tcs_course3_outcome,tcs_course4_outcome],
                        :outcome_level=>"course level",:access_type=>"change account id")
  end

  it "should show unauthorized message when TCS admin try to access IBM account's course level outcome  by changing account id" do
    outcome_corss_check(:account_name=>"tcs",:user_name=>"tcs@arrivusystems.com",:outcomes=>[ibm_course1_outcome,ibm_course2_outcome,ibm_course3_outcome,ibm_course4_outcome],
                        :outcome_level=>"course level",:access_type=>"change account id")
  end

  it "should show login page with warning message when IBM admin try to access TCS account's account level outcome by changing whole url" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:outcomes=>[ibm_course1_outcome,ibm_course2_outcome,ibm_course3_outcome,ibm_course4_outcome],
                        :checking_account_name=>"tcs",:outcome_level=>"course level",:access_type=>"change url")
  end

  it "should show login page with warning message when TCS admin try to access IBM account's account level outcome by changing whole url" do
    outcome_corss_check(:account_name=>"tcs",:user_name=>"tcs@arrivusystems.com",:outcomes=>[ibm_course1_outcome,ibm_course2_outcome,ibm_course3_outcome,ibm_course4_outcome],
                        :checking_account_name=>"ibm",:outcome_level=>"course level",:access_type=>"change url")
  end

  ##### IBM Teachers viewing course level outcomes in IBM domain

  it "should show the outcome with editing options when IBM teacher1 access their course level outcomes" do
    view_account_level_outcome(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",:outcomes=>[ibm_course1_outcome,ibm_course2_outcome],
                          :outcome_level=>"course level")
  end

  it "should show the outcome with editing options when IBM teacher2 access their course level outcomes" do
    view_account_level_outcome(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",:outcomes=>[ibm_course2_outcome,ibm_course3_outcome],
                               :outcome_level=>"course level")
  end

  it "should show the outcome with editing options when IBM teacher3 access their course level outcomes" do
    view_account_level_outcome(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",:outcomes=>[ibm_course1_outcome,ibm_course3_outcome],
                               :outcome_level=>"course level")
  end

  ##### IBM Teachers cross checking course level outcomes in IBM domain

  it "should show unauthorized message when Ibm teacher1 try to access course level outcomes without enrollment" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",:outcomes=>[ibm_course3_outcome],
                        :checking_account_name=>"ibm",:outcome_level=>"course level", :access_type=>"change account id")

  end
  it "should show unauthorized message when Ibm teacher2 try to access course level outcomes without enrollment" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",:outcomes=>[ibm_course1_outcome],
                        :checking_account_name=>"ibm",:outcome_level=>"course level", :access_type=>"change account id")

  end

  it "should show unauthorized message when Ibm teacher3 try to access course level outcomes without enrollment" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",:outcomes=>[ibm_course2_outcome],
                        :checking_account_name=>"ibm",:outcome_level=>"course level", :access_type=>"change account id")

  end

  ##### IBM Teachers cross checking course level outcomes in TCS domain by changing course id
  it "should show unauthorized message when Ibm teacher1 try to access TCS course level outcomes by changing course id" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",:outcomes=>[tcs_course2_outcome,tcs_course2_outcome,tcs_course3_outcome],
                        :checking_account_name=>"ibm",:outcome_level=>"course level", :access_type=>"change account id")

  end
  it "should show unauthorized message when Ibm teacher2 try to access TCS course level outcomes by changing course id" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",:outcomes=>[tcs_course2_outcome,tcs_course2_outcome,tcs_course3_outcome],
                        :checking_account_name=>"ibm",:outcome_level=>"course level", :access_type=>"change account id")

  end

  it "should show unauthorized message when Ibm teacher3 try to access TCS course level outcomes by changing course id" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",:outcomes=>[tcs_course2_outcome,tcs_course2_outcome,tcs_course3_outcome],
                        :checking_account_name=>"ibm",:outcome_level=>"course level", :access_type=>"change account id")

  end

  ##### IBM Teachers cross checking course level outcomes in TCS domain by changing whole url
  it "should show unauthorized message when Ibm teacher1 try to access TCS course level outcomes by changing course id" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",:outcomes=>[tcs_course2_outcome,tcs_course2_outcome,tcs_course3_outcome],
                        :checking_account_name=>"tcs",:outcome_level=>"course level", :access_type=>"change url")

  end
  it "should show unauthorized message when Ibm teacher2 try to access TCS course level outcomes by changing course id" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",:outcomes=>[tcs_course2_outcome,tcs_course2_outcome,tcs_course3_outcome],
                        :checking_account_name=>"tcs",:outcome_level=>"course level", :access_type=>"change url")

  end

  it "should show unauthorized message when Ibm teacher3 try to access TCS course level outcomes by changing course id" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",:outcomes=>[tcs_course2_outcome,tcs_course2_outcome,tcs_course3_outcome],
                        :checking_account_name=>"tcs",:outcome_level=>"course level", :access_type=>"change url")

  end

  #### IBM Students viewing course level outcomes in IBM domain

  it "should show the outcome with out editing options when IBM student1 access their course level outcomes" do
    view_account_level_outcome(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",:outcomes=>[ibm_course1_outcome,ibm_course2_outcome],
                               :outcome_level=>"course level", :user_role=>"student")
  end

  it "should show the outcome with out editing options when IBM student2 access their course level outcomes" do
    view_account_level_outcome(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",:outcomes=>[ibm_course2_outcome,ibm_course3_outcome],
                               :outcome_level=>"course level", :user_role=>"student")
  end

  it "should show the outcome with out editing options when IBM student3 access their course level outcomes" do
    view_account_level_outcome(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",:outcomes=>[ibm_course1_outcome,ibm_course3_outcome],
                               :outcome_level=>"course level", :user_role=>"student")
  end

  ##### IBM Students cross checking course level outcomes in IBM domain

  it "should show unauthorized message when Ibm student1 try to access course level outcomes without enrollment" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",:outcomes=>[ibm_course3_outcome],
                        :checking_account_name=>"ibm",:outcome_level=>"course level", :access_type=>"change account id")

  end
  it "should show unauthorized message when Ibm student2 try to access course level outcomes without enrollment" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",:outcomes=>[ibm_course1_outcome],
                        :checking_account_name=>"ibm",:outcome_level=>"course level", :access_type=>"change account id")

  end

  it "should show unauthorized message when Ibm student3 try to access course level outcomes without enrollment" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",:outcomes=>[ibm_course2_outcome],
                        :checking_account_name=>"ibm",:outcome_level=>"course level", :access_type=>"change account id")

  end

  ##### IBM Students cross checking course level outcomes in TCS domain by changing course id
  it "should show unauthorized message when Ibm student1 try to access TCS course level outcomes by changing course id" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",:outcomes=>[tcs_course2_outcome,tcs_course2_outcome,tcs_course3_outcome],
                        :checking_account_name=>"ibm",:outcome_level=>"course level", :access_type=>"change account id")

  end
  it "should show unauthorized message when Ibm student2 try to access TCS course level outcomes by changing course id" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",:outcomes=>[tcs_course2_outcome,tcs_course2_outcome,tcs_course3_outcome],
                        :checking_account_name=>"ibm",:outcome_level=>"course level", :access_type=>"change account id")

  end

  it "should show unauthorized message when Ibm student3 try to access TCS course level outcomes by changing course id" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",:outcomes=>[tcs_course2_outcome,tcs_course2_outcome,tcs_course3_outcome],
                        :checking_account_name=>"ibm",:outcome_level=>"course level", :access_type=>"change account id")

  end

  ##### IBM Students cross checking course level outcomes in TCS domain by changing whole url
  it "should show unauthorized message when Ibm student1 try to access TCS course level outcomes by changing course id" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",:outcomes=>[tcs_course2_outcome,tcs_course2_outcome,tcs_course3_outcome],
                        :checking_account_name=>"tcs",:outcome_level=>"course level", :access_type=>"change url")

  end
  it "should show unauthorized message when Ibm student2 try to access TCS course level outcomes by changing course id" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",:outcomes=>[tcs_course2_outcome,tcs_course2_outcome,tcs_course3_outcome],
                        :checking_account_name=>"tcs",:outcome_level=>"course level", :access_type=>"change url")

  end

  it "should show unauthorized message when Ibm student3 try to access TCS course level outcomes by changing course id" do
    outcome_corss_check(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",:outcomes=>[tcs_course2_outcome,tcs_course2_outcome,tcs_course3_outcome],
                        :checking_account_name=>"tcs",:outcome_level=>"course level", :access_type=>"change url")

  end

  ##### Teacher as a student going to view outcome in same domain

  it "should show the outcome with out editing options when IBM teacher1 as a student in IBM domain, access their course level outcomes" do
    view_account_level_outcome(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",:outcomes=>[ibm_course4_outcome],
                               :outcome_level=>"course level", :user_role=>"student")
  end

  it "should show the outcome with out editing options when TCS teacher1 as a student in TCS domain, access their course level outcomes" do
    view_account_level_outcome(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",:outcomes=>[tcs_course4_outcome],
                               :outcome_level=>"course level", :user_role=>"student")
  end

  it "should show the outcome with out editing options when IBM teacher1 as a student in TCS domain, access their course level outcomes" do
    view_account_level_outcome(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",:outcomes=>[tcs_course4_outcome],
                               :outcome_level=>"course level", :user_role=>"student")
  end

  it "should show the outcome with out editing options when TCS teacher1 as a student in IBM domain, access their course level outcomes" do
    view_account_level_outcome(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",:outcomes=>[ibm_course4_outcome],
                               :outcome_level=>"course level", :user_role=>"student")
  end

end
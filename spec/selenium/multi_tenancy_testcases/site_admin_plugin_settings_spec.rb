require File.expand_path(File.dirname(__FILE__) + '/common_mt')
require File.expand_path(File.dirname(__FILE__) + '/data_setup')

  describe "Site_Admin user creation test" do

    it_should_behave_like "in-process server selenium tests"


    account=create_site_admin("Sublime","Sublime@arrivusystems.com","Admin123$")
    #ibm_account=add_mt_account("ibm")
    #add_mt_account_admin_users("ibm","ibm@arrivusystems.com","Admin123$")
    #ibm_course=create_course("IBM course M1-Sample Course1","IBMM1","ibm")


    def admin_login(params={})
      driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
      fill_in_login_form(params[:user_name],params[:password])
      wait_for_ajaximations
      f('.user_name').text.should == params[:user_name]
      driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/accounts/#{params[:account_id]}/settings"
    end

    def submit_updated_form(params={})

      admin_login(:account_name=>params[:account_name],:user_name=>params[:user_name],:password=>params[:password],:account_id=>params[:account_id])
      #driver.get "http://Sublime.lvh.me:#{$server_port}/accounts/#{ibm_account.id}"
      f("#tab-plugin-link").click
      driver.find_element(:id, params[:css_selector]).click
      submit_form("#account_plugin_settings")
    end

    def site_admin_logout
      expect_new_page_load { f('.logout > a').click }
    end

    before do
      @login_error_box_css = ".error_text:last"
    end

    it "should login as a site administrator to disable grades for ibm account" do

      admin_login(:account_name=>"Sublime",:user_name=>"Sublime@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)
      f("#tab-plugin-link").should be_displayed
      f("#tab-plugin-link").click
      driver.find_element(:id, 'account_settings_Sublime_grade_disable').click
      submit_form("#account_plugin_settings")

      #to check in quizzes
      driver.find_element(:css,'body').send_keys [:control,'t']
      #driver.get "http://ibm.lvh.me:#{$server_port}"
      #fill_in_login_form("ibm@arrivusystems.com","Admin123$")
      admin_login(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)
      fj('.menu-item-no-drop').should be_nil
      fj('#grades_menu_item').should be_nil
      #driver.get "http://ibm.lvh.me:#{$server_port}/accounts/#{ibm_account.id}"
      f('.grading_standards').text.should=="Grading Schemes"
      fj('.grading_standards').click
      driver.find_element(:id, 'content').should be_displayed
      f("#content").text.should include_text "Feature is not Enabled"
      driver.find_element(:id, 'feature_wish_submit').should be_displayed
      driver.find_element(:id, 'feature_wish_submit').click
      assert_flash_notice_message /Your request was sent to admin,The administrator will contact you soon/
      sleep(2)

      #check, are the grading schemes present in quizzes or not
      driver.get "http://ibm.lvh.me:#{$server_port}/courses/#{ibm_course.id}/quizzes"
      expect_new_page_load {fj("a:contains(' Create a New Quiz')").click }
      driver.find_element(:id, 'quiz_edit_wrapper').should be_displayed
      driver.find_element(:id, 'quiz_tabs').should be_displayed
      driver.find_element(:id, 'ui-id-1').should be_displayed
      driver.find_element(:id, 'quiz_assignment_id').should be_displayed
      f("#quiz_assignment_id").click
      sleep(2)
      f("#quiz_assignment_id").should have_value "practice_quiz"
      f("#quiz_assignment_id").should_not have_value "assignment"
      f("#quiz_assignment_id").should_not have_value "graded_survey"
      sleep(2)

      #check, are the grading schemes present in course settings
      driver.get "http://ibm.lvh.me:#{$server_port}/courses/#{ibm_course.id}/gradebook2"
      #driver.get "http://ibm.lvh.me:#{$server_port}/courses/#{ibm_course.id}/gradebook2"
      #if it is old gradebook, this testwill fail
      driver.find_element(:id, 'content').should be_displayed
      f("#content").text.should include_text "Feature is not Enabled"
      driver.find_element(:id, 'feature_wish_submit').should be_displayed
      driver.find_element(:id, 'feature_wish_submit').click
      assert_flash_notice_message /Your request was sent to admin,The administrator will contact you soon/

      #to check grade in creating discussions
      driver.get "http://ibm.lvh.me:#{$server_port}/courses/#{ibm_course.id}/discussion_topics"
      driver.find_element(:id, 'new-discussion-btn').click
      #can use follows instead above two lines
      #driver.get "http://ibm.lvh.me:#{$server_port}/courses/#{ibm_course.id}/discussion_topics/new"
      driver.find_element(:id, 'discussion-title').should be_displayed
      #f("#use_for_grading").should_not be_displayed
      #f('.custom_help_link:nth-child(2)').should_not be_displayed
      fj('#use_for_grading:visible').should be_nil

    end

    it "should login as a site administrator to disable outcomes for ibm account" do
      #switch to previous tab
      driver.find_element(:css,'body').send_keys [:alt,'1']
      admin_login(:account_name=>"Sublime",:user_name=>"Sublime@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)
      #driver.get "http://Sublime.lvh.me:#{$server_port}/accounts/#{ibm_account.id}"
      f("#tab-plugin-link").click
      driver.find_element(:id, 'account_settings_Sublime_grade_disable').click
      driver.find_element(:id, 'account_settings_Sublime_outcomes_disable').click
      sleep 2
      submit_form("#account_plugin_settings")
      driver.find_element(:css,'body').send_keys [:alt,'2']
      admin_login(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)
      driver.get "http://ibm.lvh.me:#{$server_port}/accounts/#{ibm_account.id}"
      f('.outcomes').text.should=="Outcomes"
      fj('.outcomes').click

      driver.find_element(:id, 'content').should be_displayed
      f("#content").text.should include_text "Feature is not Enabled"
      driver.find_element(:id, 'feature_wish_submit').should be_displayed
      driver.find_element(:id, 'feature_wish_submit').click
      assert_flash_notice_message /Your request was sent to admin,The administrator will contact you soon/
      sleep(2)

      #check in rubric -  optional()
      driver.get "http://ibm.lvh.me:#{$server_port}/accounts/#{ibm_account.id}/rubrics"
      fj("a:contains(' Add Rubric')").click
      fj("a:contains('Find Outcome Criterion')").should be_displayed
      #correct code should not be displayed
      #fj("a:contains('Find Outcome Criterion')").should_not be_displayed
    end

    it "should disable course import" do

      driver.find_element(:css,'body').send_keys [:alt,'1']
      admin_login(:account_name=>"Sublime",:user_name=>"Sublime@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)
      #driver.get "http://Sublime.lvh.me:#{$server_port}/accounts/#{ibm_account.id}"
      f("#tab-plugin-link").click
      driver.find_element(:id, 'account_settings_Sublime_course_import_disable').click
      sleep 2
      submit_form("#account_plugin_settings")
      driver.find_element(:css,'body').send_keys [:alt,'2']

      admin_login(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)
      driver.get "http://ibm.lvh.me:#{$server_port}/courses/#{ibm_course.id}/settings"
      f("#course_details_tabs").should be_displayed
      fj("a:contains(' Edit Course Details')").should be_displayed
      fj('.icon-download:visible').should be_nil
      sleep 2

      #check with import url
      driver.get "http://ibm.lvh.me:#{$server_port}/courses/#{ibm_course.id}/imports"
      driver.find_element(:id, 'content').should be_displayed
      f("#content").text.should include_text "Feature is not Enabled"
      driver.find_element(:id, 'feature_wish_submit').should be_displayed
      driver.find_element(:id, 'feature_wish_submit').click
      assert_flash_notice_message /Your request was sent to admin,The administrator will contact you soon/
      sleep 1

    end

    it "should disable course export" do

      driver.find_element(:css,'body').send_keys [:alt,'1']
      admin_login(:account_name=>"Sublime",:user_name=>"Sublime@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)
      #driver.get "http://Sublime.lvh.me:#{$server_port}/accounts/#{ibm_account.id}"
      f("#tab-plugin-link").click
      driver.find_element(:id, 'account_settings_Sublime_course_export_disable').click
      submit_form("#account_plugin_settings")
      driver.find_element(:css,'body').send_keys [:alt,'2']
      admin_login(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)
      driver.get "http://ibm.lvh.me:#{$server_port}/courses/#{ibm_course.id}/settings"
      f("#course_details_tabs").should be_displayed
      fj("a:contains(' Edit Course Details')").should be_displayed
      fj('.icon-upload:visible').should be_nil
      sleep 2

      #check with export url
      driver.get "http://ibm.lvh.me:#{$server_port}/courses/#{ibm_course.id}/content_exports"
      driver.find_element(:id, 'content').should be_displayed
      f("#content").text.should include_text "Feature is not Enabled"
      driver.find_element(:id, 'feature_wish_submit').should be_displayed
      driver.find_element(:id, 'feature_wish_submit').click
      assert_flash_notice_message /Your request was sent to admin,The administrator will contact you soon/
      sleep 1
    end

    it "should disable sub account" do

      driver.find_element(:css,'body').send_keys [:alt,'1']
      admin_login(:account_name=>"Sublime",:user_name=>"Sublime@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)
      #driver.get "http://Sublime.lvh.me:#{$server_port}/accounts/#{ibm_account.id}"
      f("#tab-plugin-link").click
      driver.find_element(:id, 'account_settings_Sublime_sub_account_disable').click
      submit_form("#account_plugin_settings")
      driver.find_element(:css,'body').send_keys [:alt,'2']
      admin_login(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)
      driver.get "http://ibm.lvh.me:#{$server_port}/accounts/#{ibm_account.id}/settings"

      f('.sub_accounts').text.should=="Sub-Accounts"
      fj('.sub_accounts').click
      #or  driver.get "http://ibm.lvh.me:#{$server_port}/accounts/#{ibm_account.id}/sub_accounts"
      driver.find_element(:id, 'content').should be_displayed
      f("#content").text.should include_text "Feature is not Enabled"
      driver.find_element(:id, 'feature_wish_submit').should be_displayed
      driver.find_element(:id, 'feature_wish_submit').click
      assert_flash_notice_message /Your request was sent to admin,The administrator will contact you soon/
      sleep(2)
    end



    it "should Enable self registration link in login page" do

      driver.find_element(:css,'body').send_keys [:alt,'1']
      admin_login(:account_name=>"Sublime",:user_name=>"Sublime@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)
      #driver.get "http://Sublime.lvh.me:#{$server_port}/accounts/#{ibm_account.id}"
      f("#tab-plugin-link").click
      driver.find_element(:id, 'account_settings_self_registration').click
      submit_form("#account_plugin_settings")
      driver.find_element(:css,'body').send_keys [:alt,'2']

      driver.get "http://ibm.lvh.me:#{$server_port}/login"
      fj("a:contains('Need a Sublime Account?')").should be_displayed
      driver.find_element(:id, 'register_link').should be_displayed
      expect_new_page_load {driver.find_element(:id, 'register_link').click}

      driver.find_element(:id, 'registration_options').should be_displayed
      driver.find_element(:id, 'signup_teacher').should be_displayed
      driver.find_element(:id, 'signup_student').should be_displayed
      driver.find_element(:id, 'signup_parent').should be_displayed
      driver.current_url.ends_with?("/register_from_website").should == true
      sleep 2
      # if we diable self registration
      #driver.get "http://ibm.lvh.me:#{$server_port}/register_from_website"
      #driver.current_url.ends_with?("/login").should == true
      #assert_flash_notice_message /Self registration has not been enabled for this account/

    end

    it "should disable adding new courses" do
      driver.find_element(:css,'body').send_keys [:alt,'1']
      submit_updated_form(:account_name=>"Sublime",:user_name=>"Sublime@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id, :css_selector=>'account_settings_Sublime_add_course_disable')
      driver.find_element(:css,'body').send_keys [:alt,'2']
      admin_login(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)

      fj('.add_course_link btn .button-sidebar-wide:visible').should be_nil
      sleep 2

      #check in courses index page
      driver.get "http://ibm.lvh.me:#{$server_port}/accounts/#{ibm_account.id}"
      fj('.add_course_link .btn .button-sidebar-wide:visible').should be_nil

      #check in home page
      driver.get "http://ibm.lvh.me:#{$server_port}"
      fj('#start_new_course:visible').should be_nil
    end



    it "should disable adding new courses" do
      driver.find_element(:css,'body').send_keys [:alt,'1']
      submit_updated_form(:account_name=>"Sublime",:user_name=>"Sublime@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id, :css_selector=>'account_settings_Sublime_add_user_disable')
      driver.find_element(:css,'body').send_keys [:alt,'2']
      admin_login(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)

      fj('.add_course_link btn .button-sidebar-wide:visible').should be_nil
      #check in courses index page
      driver.get "http://ibm.lvh.me:#{$server_port}/accounts/#{ibm_account.id}"
      fj('.add_user_link .btn .button-sidebar-wide:visible').should be_nil
      #check in users index

      driver.get "http://ibm.lvh.me:#{$server_port}/accounts/#{ibm_account.id}/users"
      fj('.add_user_link .btn .button-sidebar-wide:visible').should be_nil

      sleep 2
    end

    it "should disable adding new courses" do
      driver.find_element(:css,'body').send_keys [:alt,'1']
      admin_login(:account_name=>"Sublime",:user_name=>"Sublime@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)
      f("#tab-plugin-link").click
      driver.find_element(:id, 'account_settings_Sublime_grade_disable').click
      driver.find_element(:id, 'account_settings_Sublime_outcomes_disable').click
      driver.find_element(:id, 'account_settings_Sublime_sub_account_disable').click
      driver.find_element(:id, 'account_settings_Sublime_show_lock_menu').click
      submit_form("#account_plugin_settings")

      driver.find_element(:css,'body').send_keys [:alt,'2']
      admin_login(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)

      fj('.outcomes').should be_nil
      fj('.grading_standards').should be_nil
      fj('.sub_accounts').should be_nil
    end


    it "should set the Number of user" do
      driver.find_element(:css,'body').send_keys [:alt,'1']
      admin_login(:account_name=>"Sublime",:user_name=>"Sublime@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)
      f("#tab-plugin-link").click

      f('#account_settings_Sublime_max_users').send_keys("1")
      submit_form("#account_plugin_settings")
      sleep 3
      driver.find_element(:css,'body').send_keys [:alt,'2']
      admin_login(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)
      fj("a:contains(' Add a New User')").click
      #or f(".add_user_link").click
      driver.find_element(:id,'add_user_dialog').should be_displayed
      driver.find_element(:id,'add_user_form').should be_displayed
      driver.find_element(:id,'pseudonym_unique_id').should be_displayed
      f("#add_user_form #user_name").send_keys ("ibm student1")
      f('#pseudonym_unique_id').send_keys("ibm.st1@arrivusystems.com")
      f('#user_name').send_keys("ibmstudent1")
      fj("span:contains('Add User')").click
      #driver.find_element(:css, ".error_text").should include_text "Your Sublime User creation limit is exceeded. Please contact your account admin"
      f('.error_text').should be_displayed

      driver.get "http://ibm.lvh.me:#{$server_port}/courses/#{ibm_course.id}/users"
      f("#addUsers").click
      f("#create-users-step-1").should be_displayed
      f("#user_list_textarea").send_keys("ibm.st1@arrivusystems.com")
      f("#next-step").click
      f("#create-users-verified").text.should include_text "ibm.st1@arrivusystems.com"
      f("#createUsersAddButton").click
      wait_for_ajaximations
      f("#create-users-step-3").should_not be_displayed
    end


    it "should set the Number of courses" do
      driver.find_element(:css,'body').send_keys [:alt,'1']
      admin_login(:account_name=>"Sublime",:user_name=>"Sublime@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)
      f("#tab-plugin-link").click

      f('#account_settings_Sublime_max_courses').send_keys("1")
      submit_form("#account_plugin_settings")
      sleep 3
      driver.find_element(:css,'body').send_keys [:alt,'2']
      admin_login(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:password=>"Admin123$",:account_id=>ibm_account.id)
      fj("a:contains(' Add a New Course')").click
      driver.find_element(:id,'add_course_dialog').should be_displayed
      driver.find_element(:id,'add_course_form').should be_displayed
      f("#add_course_form #course_name").send_keys ("ibm_course2")
      f('#course_course_code').send_keys("ibm002")
      fj("span:contains('Add Course')").click
      f('.error_text').should be_displayed

      driver.get "http://ibm.lvh.me:#{$server_port}"

      driver.find_element(:id, 'start_new_course').click

      driver.find_element(:id,'new_course_form').should be_displayed
      f("#new_course_form #course_name").send_keys("ibmcourse2")
      fj("span:contains('Create course')").click
      assert_flash_error_message /Your Sublime Course creation limit is exceeded.Please contact your account admin/
      sleep 2
    end


  end
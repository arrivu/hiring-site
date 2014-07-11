    require File.expand_path(File.dirname(__FILE__) + '/common_mt')
    #require File.expand_path(File.dirname(__FILE__) + '/data_setup')

    describe "Course_cross_checking" do

      it_should_behave_like "in-process server selenium tests"

      ibm_account=add_mt_account("ibm")
      tcs_account=add_mt_account("tcs")

      ibm_admin_user=add_mt_account_admin_users("ibm","ibm@arrivusystems.com","Admin123$")
      tcs_admin_user=add_mt_account_admin_users("tcs","tcs@arrivusystems.com","Admin123$")

      ibm_sub_account1=add_sub_account_mt("ibm","ibm_sub_account1","ibm.s1@arrivusystems.com","Admin123$")
      ibm_sub_account2=add_sub_account_mt("ibm","ibm_sub_account2","ibm.s2@arrivusystems.com","Admin123$")
      tcs_sub_account1=add_sub_account_mt("tcs","tcs_sub_account1","tcs.s1@arrivusystems.com","Admin123$")
      tcs_sub_account2=add_sub_account_mt("tcs","tcs_sub_account2","tcs.s2@arrivusystems.com","Admin123$")

      ibm_course_m1=course(:course_name=>"IBM course M1-Main Account Course1", :account=>ibm_account, :active_course=>true)
      ibm_course_m2=course(:course_name=>"IBM course M2-Main Account Course2", :account=>ibm_account, :active_course=>true)
      ibm_course_ms1=course(:course_name=>"IBM course MS1-Sub Account Course by Main Account Course1", :account=>ibm_sub_account1, :active_course=>true)
      ibm_course_ms2=course(:course_name=>"IBM course MS2-Sub Account Course by Main Account Course2", :account=>ibm_sub_account2, :active_course=>true)
      ibm_course_s1=course(:course_name=>"IBM course S1-Sub Account Course1", :account=>ibm_sub_account1, :active_course=>true)
      ibm_course_s2=course(:course_name=>"IBM course S2-Sub Account Course2", :account=>ibm_sub_account1, :active_course=>true)
      ibm_course_s3=course(:course_name=>"IBM course S3-Sub Account Course3", :account=>ibm_sub_account2, :active_course=>true)
      ibm_course_s4=course(:course_name=>"IBM course S4-Sub Account Course4", :account=>ibm_sub_account2, :active_course=>true)

      tcs_course_m1=course(:course_name=>"tcs course M1-Main Account Course1", :account=>tcs_account, :active_course=>true)
      tcs_course_m2=course(:course_name=>"tcs course M2-Main Account Course2", :account=>tcs_account, :active_course=>true)
      tcs_course_ms1=course(:course_name=>"tcs course MS1-Sub Account Course by Main Account Course1", :account=>tcs_sub_account1, :active_course=>true)
      tcs_course_ms2=course(:course_name=>"tcs course MS2-Sub Account Course by Main Account Course2", :account=>tcs_sub_account2, :active_course=>true)
      tcs_course_s1=course(:course_name=>"tcs course S1-Sub Account Course1", :account=>tcs_sub_account1, :active_course=>true)
      tcs_course_s2=course(:course_name=>"tcs course S2-Sub Account Course2", :account=>tcs_sub_account1, :active_course=>true)
      tcs_course_s3=course(:course_name=>"tcs course S3-Sub Account Course3", :account=>tcs_sub_account2, :active_course=>true)
      tcs_course_s4=course(:course_name=>"tcs course S4-Sub Account Course4", :account=>tcs_sub_account2, :active_course=>true)

      ibm_student1=add_user("ibm","ibm.st1@arrivusystems.com","Admin123$")
      ibm_student2=add_user("ibm","ibm.st2@arrivusystems.com","Admin123$")
      ibm_student3=add_user("ibm","ibm.st3@arrivusystems.com","Admin123$")
      ibm_student4=add_user("ibm","ibm.st4@arrivusystems.com","Admin123$")
      ibm_student5=add_user("ibm","ibm.st5@arrivusystems.com","Admin123$")

      ibm_teacher1=add_user("ibm","ibm.tr1@arrivusystems.com","Admin123$")
      ibm_teacher2=add_user("ibm","ibm.tr2@arrivusystems.com","Admin123$")
      ibm_teacher3=add_user("ibm","ibm.tr3@arrivusystems.com","Admin123$")
      ibm_teacher4=add_user("ibm","ibm.tr4@arrivusystems.com","Admin123$")
      ibm_teacher5=add_user("ibm","ibm.tr5@arrivusystems.com","Admin123$")


      tcs_student1=add_user("tcs","tcs.st1@arrivusystems.com","Admin123$")
      tcs_student2=add_user("tcs","tcs.st2@arrivusystems.com","Admin123$")
      tcs_student3=add_user("tcs","tcs.st3@arrivusystems.com","Admin123$")
      tcs_student4=add_user("tcs","tcs.st4@arrivusystems.com","Admin123$")
      tcs_student5=add_user("tcs","tcs.st5@arrivusystems.com","Admin123$")

      tcs_teacher1=add_user("tcs","tcs.tr1@arrivusystems.com","Admin123$")
      tcs_teacher2=add_user("tcs","tcs.tr2@arrivusystems.com","Admin123$")
      tcs_teacher3=add_user("tcs","tcs.tr3@arrivusystems.com","Admin123$")
      tcs_teacher4=add_user("tcs","tcs.tr4@arrivusystems.com","Admin123$")
      tcs_teacher5=add_user("tcs","tcs.tr5@arrivusystems.com","Admin123$")

      ibm_course_m1.enroll_user(ibm_student1,'StudentEnrollment',:enrollment_state=>'active')
      ibm_course_ms1.enroll_user(ibm_student1,'StudentEnrollment',:enrollment_state=>'active')
      ibm_course_s1.enroll_user(ibm_student1,'StudentEnrollment',:enrollment_state=>'active')

      ibm_course_m1.enroll_user(ibm_teacher1,'TeacherEnrollment',:enrollment_state=>'active')
      ibm_course_ms1.enroll_user(ibm_teacher1,'TeacherEnrollment',:enrollment_state=>'active')
      ibm_course_s1.enroll_user(ibm_teacher1,'TeacherEnrollment',:enrollment_state=>'active')

      ibm_course_m1.enroll_user(ibm_student2,'StudentEnrollment',:enrollment_state=>'active')
      ibm_course_ms1.enroll_user(ibm_student2,'StudentEnrollment',:enrollment_state=>'active')
      ibm_course_s2.enroll_user(ibm_student2,'StudentEnrollment',:enrollment_state=>'active')

      ibm_course_m1.enroll_user(ibm_teacher2,'TeacherEnrollment',:enrollment_state=>'active')
      ibm_course_ms1.enroll_user(ibm_teacher2,'TeacherEnrollment',:enrollment_state=>'active')
      ibm_course_s2.enroll_user(ibm_teacher2,'TeacherEnrollment',:enrollment_state=>'active')

      ibm_course_m1.enroll_user(ibm_student3,'StudentEnrollment',:enrollment_state=>'active')
      ibm_course_ms1.enroll_user(ibm_student3,'StudentEnrollment',:enrollment_state=>'active')
      ibm_course_s3.enroll_user(ibm_student3,'StudentEnrollment',:enrollment_state=>'active')

      ibm_course_m1.enroll_user(ibm_teacher3,'TeacherEnrollment',:enrollment_state=>'active')
      ibm_course_ms1.enroll_user(ibm_teacher3,'TeacherEnrollment',:enrollment_state=>'active')
      ibm_course_s3.enroll_user(ibm_teacher3,'TeacherEnrollment',:enrollment_state=>'active')

      ibm_course_m2.enroll_user(ibm_student4,'StudentEnrollment',:enrollment_state=>'active')
      ibm_course_ms2.enroll_user(ibm_student4,'StudentEnrollment',:enrollment_state=>'active')
      ibm_course_s4.enroll_user(ibm_student4,'StudentEnrollment',:enrollment_state=>'active')

      ibm_course_m2.enroll_user(ibm_teacher4,'TeacherEnrollment',:enrollment_state=>'active')
      ibm_course_ms2.enroll_user(ibm_teacher4,'TeacherEnrollment',:enrollment_state=>'active')
      ibm_course_s4.enroll_user(ibm_teacher4,'TeacherEnrollment',:enrollment_state=>'active')

      ibm_course_m2.enroll_user(ibm_student5,'StudentEnrollment',:enrollment_state=>'active')
      ibm_course_ms2.enroll_user(ibm_student5,'StudentEnrollment',:enrollment_state=>'active')
      ibm_course_s1.enroll_user(ibm_student5,'StudentEnrollment',:enrollment_state=>'active')

      ibm_course_m2.enroll_user(ibm_teacher5,'TeacherEnrollment',:enrollment_state=>'active')
      ibm_course_ms2.enroll_user(ibm_teacher5,'TeacherEnrollment',:enrollment_state=>'active')
      ibm_course_s1.enroll_user(ibm_teacher5,'TeacherEnrollment',:enrollment_state=>'active')



      tcs_course_m1.enroll_user(tcs_student1,'StudentEnrollment',:enrollment_state=>'active')
      tcs_course_ms1.enroll_user(tcs_student1,'StudentEnrollment',:enrollment_state=>'active')
      tcs_course_s1.enroll_user(tcs_student1,'StudentEnrollment',:enrollment_state=>'active')

      tcs_course_m1.enroll_user(tcs_teacher1,'TeacherEnrollment',:enrollment_state=>'active')
      tcs_course_ms1.enroll_user(tcs_teacher1,'TeacherEnrollment',:enrollment_state=>'active')
      tcs_course_s1.enroll_user(tcs_teacher1,'TeacherEnrollment',:enrollment_state=>'active')

      tcs_course_m1.enroll_user(tcs_student2,'StudentEnrollment',:enrollment_state=>'active')
      tcs_course_ms1.enroll_user(tcs_student2,'StudentEnrollment',:enrollment_state=>'active')
      tcs_course_s2.enroll_user(tcs_student2,'StudentEnrollment',:enrollment_state=>'active')

      tcs_course_m1.enroll_user(tcs_teacher2,'TeacherEnrollment',:enrollment_state=>'active')
      tcs_course_ms1.enroll_user(tcs_teacher2,'TeacherEnrollment',:enrollment_state=>'active')
      tcs_course_s2.enroll_user(tcs_teacher2,'TeacherEnrollment',:enrollment_state=>'active')

      tcs_course_m1.enroll_user(tcs_student3,'StudentEnrollment',:enrollment_state=>'active')
      tcs_course_ms1.enroll_user(tcs_student3,'StudentEnrollment',:enrollment_state=>'active')
      tcs_course_s3.enroll_user(tcs_student3,'StudentEnrollment',:enrollment_state=>'active')

      tcs_course_m1.enroll_user(tcs_teacher3,'TeacherEnrollment',:enrollment_state=>'active')
      tcs_course_ms1.enroll_user(tcs_teacher3,'TeacherEnrollment',:enrollment_state=>'active')
      tcs_course_s3.enroll_user(tcs_teacher3,'TeacherEnrollment',:enrollment_state=>'active')

      tcs_course_m2.enroll_user(tcs_student4,'StudentEnrollment',:enrollment_state=>'active')
      tcs_course_ms2.enroll_user(tcs_student4,'StudentEnrollment',:enrollment_state=>'active')
      tcs_course_s4.enroll_user(tcs_student4,'StudentEnrollment',:enrollment_state=>'active')

      tcs_course_m2.enroll_user(tcs_teacher4,'TeacherEnrollment',:enrollment_state=>'active')
      tcs_course_ms2.enroll_user(tcs_teacher4,'TeacherEnrollment',:enrollment_state=>'active')
      tcs_course_s4.enroll_user(tcs_teacher4,'TeacherEnrollment',:enrollment_state=>'active')

      tcs_course_m2.enroll_user(tcs_student5,'StudentEnrollment',:enrollment_state=>'active')
      tcs_course_ms2.enroll_user(tcs_student5,'StudentEnrollment',:enrollment_state=>'active')
      tcs_course_s1.enroll_user(tcs_student5,'StudentEnrollment',:enrollment_state=>'active')

      tcs_course_m2.enroll_user(tcs_teacher5,'TeacherEnrollment',:enrollment_state=>'active')
      tcs_course_ms2.enroll_user(tcs_teacher5,'TeacherEnrollment',:enrollment_state=>'active')
      tcs_course_s1.enroll_user(tcs_teacher5,'TeacherEnrollment',:enrollment_state=>'active')

      #cross check for enrollment
      tcs_course_m2.enroll_user(tcs_teacher1,"StudentEnrollment",:enrollment_state=>'active')
      ibm_course_m1.enroll_user(tcs_teacher1,"StudentEnrollment",:enrollment_state=>'active')

      ibm_course_m2.enroll_user(ibm_teacher1,"StudentEnrollment",:enrollment_state=>'active')
      tcs_course_m1.enroll_user(ibm_teacher1,"StudentEnrollment",:enrollment_state=>'active')

      def course_check_by_user(params={})
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
        fill_in_login_form(params[:user_name],"Admin123$")
        wait_for_ajaximations
        f('.user_name').text.should == params[:user_name]
        params[:course_id].each do |course_id|
          driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses"
          course_name=Course.find(course_id).name
          f("#menu_enrollments").text.should include_text course_name
          f("#content").text.should include_text course_name
          if params[:user_role]=="teacher"
            driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course_id}/settings"
            f("#course_form").should be_displayed
            f('#course_form').text.should include_text course_name
          elsif params[:user_role]=="student"
            expect_new_page_load{driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course_id}"}
          end
        end
        sleep 5
        expect_new_page_load { f('.logout > a').click }
      end

      def course_check_by_admin(params={})
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
        fill_in_login_form(params[:user_name],"Admin123$")
        wait_for_ajaximations
        f('.user_name').text.should == params[:user_name]
        params[:course_id].each do |course_id|
        course_name=Course.find(course_id).name
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/accounts/#{params[:account_id]}"
        driver.find_element(:id,"course_#{course_id}").should be_displayed
        driver.find_element(:id,"course_#{course_id}").text.should include_text course_name
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course_id}/settings"
        f("#course_form").should be_displayed
        f('#course_form').text.should include_text course_name
        end

        expect_new_page_load { f('.logout > a').click }
      end

      def course_cross_checking(params={})
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
        fill_in_login_form(params[:user_name],"Admin123$")
        wait_for_ajaximations
        f('.user_name').text.should == params[:user_name]
        if params[:access_type]=="change course id"
          driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{params[:course_id]}"
          driver.find_element(:id,"unauthorized_holder").should be_displayed
          driver.find_element(:id,"unauthorized_message").should be_displayed
          f('.ui-state-error').should include_text("Unauthorized")
          #driver.find_element(:id,"unauthorized_message").should include_text("Unauthorized It appears that you don't have permission to access this page. Please make sure you're authorized to view this content.")
        end

        if params[:access_type]=="change url"
          driver.get "http://#{params[:cross_account_name]}.lvh.me:#{$server_port}/courses/#{params[:course_id]}"
          driver.find_element(:id,"unauthorized_message").should be_displayed
          driver.find_element(:id,"login_form").should be_displayed
          f('.ui-state-error').should include_text("Please Log In")
          driver.find_element(:id,"pseudonym_session_unique_id").should be_displayed
          driver.find_element(:id,"pseudonym_session_password").should be_displayed
        end
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
        expect_new_page_load { f('.logout > a').click }
      end


      def course_cross_check_by_user(params={})
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
        fill_in_login_form(params[:user_name],"Admin123$")
        wait_for_ajaximations
        f('.user_name').text.should == params[:user_name]
        params[:course_id].each do |course_id|
          if params[:access_type]=="change course id"
            driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses"
            driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course_id}"
           # driver.find_element(:id,"unauthorized_holder").should be_displayed
            driver.find_element(:id,"unauthorized_message").should be_displayed
            f('.ui-state-error').should include_text("Unauthorized")
          end
          if params[:access_type]=="change url"
            driver.get "http://#{params[:checking_account_name]}.lvh.me:#{$server_port}/courses/#{course_id}"
            driver.find_element(:id,"unauthorized_message").should be_displayed
            driver.find_element(:id,"login_form").should be_displayed
            f('.ui-state-error').should include_text("Please Log In")
            driver.find_element(:id,"pseudonym_session_unique_id").should be_displayed
            driver.find_element(:id,"pseudonym_session_password").should be_displayed
          end
        end
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
        expect_new_page_load { f('.logout > a').click }
      end

      def teacher_as_a_student(params={})
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
        fill_in_login_form(params[:user_name],"Admin123$")
        wait_for_ajaximations
        f('.user_name').text.should == params[:user_name]
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{params[:course_id]}"
        f('#section-tabs-header').should be_displayed
        f('#course_home_content').should be_displayed
        fj('.settings').should be_nil
        fj('.outcomes').should be_nil
        fj("a:contains(' Edit Syllabus Description')").should be_nil
        fj("a:contains(' New Announcement')").should be_nil
        fj("a:contains(' Course Setup Checklist')").should be_nil
        fj('.edit_course_home_content_link').should be_nil
        fj('.edit_course_home_content_link').should be_nil
        expect_new_page_load { f('.logout > a').click }
      end

      #Admin course check
      it "should login as a Admin in IBM domain" do
        course_check_by_admin(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:account_id=>ibm_account.id,
                           :course_id=>[ibm_course_m1.id,ibm_course_m2.id, ibm_course_ms1.id, ibm_course_ms2.id,
                                        ibm_course_s1.id,ibm_course_s2.id,ibm_course_s3.id,ibm_course_s4.id])
      end

      it "should login as a Admin in TCS domain" do
        course_check_by_admin(:account_name=>"tcs",:user_name=>"tcs@arrivusystems.com",:account_id=>tcs_account.id,
                           :course_id=>[tcs_course_m1.id,tcs_course_m2.id, tcs_course_ms1.id, tcs_course_ms2.id,
                                        tcs_course_s1.id,tcs_course_s2.id,tcs_course_s3.id,tcs_course_s4.id])
      end

      #Admin course cross checking

      it "should show unauthorized message when IBM admin tried to accessing TCS domain's course by giving TCS course id" do
        course_cross_checking(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:cross_account_name=>"tcs",:course_id=>tcs_course_m1.id,:access_type=>"change course id")
      end

      it "should show Login message when IBM admin tried to accessing TCS domain's course with TCS url" do
        course_cross_checking(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:cross_account_name=>"tcs",:course_id=>tcs_course_m1.id,:access_type=>"change url")
      end

      it "should show unauthorized message when TCS admin tried to accessing IBM domain's course by giving IBM course id" do
        course_cross_checking(:account_name=>"tcs",:user_name=>"tcs@arrivusystems.com",:cross_account_name=>"ibm",:course_id=>ibm_course_m1.id,:access_type=>"change course id")
      end

      it "should show Login message when TCS admin tried to accessing IBM domain's course with IBM url" do
        course_cross_checking(:account_name=>"tcs",:user_name=>"tcs@arrivusystems.com",:cross_account_name=>"ibm",:course_id=>ibm_course_m1.id,:access_type=>"change url")
      end


      # Sub Account check
      it "should login as a Sub Account Admin in IBM domain" do
        course_check_by_admin(:account_name=>"ibm",:user_name=>"ibm.s1@arrivusystems.com",:account_id=>ibm_sub_account1.id,
                           :course_id=>[ibm_course_ms1.id,ibm_course_s1.id,ibm_course_s2.id])

        course_check_by_admin(:account_name=>"ibm",:user_name=>"ibm.s2@arrivusystems.com",:account_id=>ibm_sub_account2.id,
                           :course_id=>[ ibm_course_ms2.id,ibm_course_s3.id,ibm_course_s4.id])
      end

      it "should login as a Sub Account Admin in TCS domain" do
        course_check_by_admin(:account_name=>"tcs",:user_name=>"tcs.s1@arrivusystems.com",:account_id=>tcs_sub_account1.id,
                           :course_id=>[tcs_course_ms1.id,tcs_course_s1.id,tcs_course_s2.id])

        course_check_by_admin(:account_name=>"tcs",:user_name=>"tcs.s2@arrivusystems.com",:account_id=>tcs_sub_account2.id,
                           :course_id=>[ tcs_course_ms2.id,tcs_course_s3.id,tcs_course_s4.id])
      end

      #Sub Account Cross checking

      it "should show unauthorized message when IBM's Sub Account1 admin tried to accessing IBM's Main Account's course by giving IBM course id" do
        course_cross_checking(:account_name=>"ibm",:user_name=>"ibm.s1@arrivusystems.com",:course_id=>ibm_course_m1.id,:access_type=>"change course id")
      end

      it "should show unauthorized message when IBM's Sub Account2 admin tried to accessing IBM's Main Account's course by giving IBM course id" do
        course_cross_checking(:account_name=>"ibm",:user_name=>"ibm.s2@arrivusystems.com",:course_id=>ibm_course_m1.id,:access_type=>"change course id")
      end

      it "should show unauthorized message when IBM's Sub Account1 admin tried to accessing IBM's Sub Account2's course by giving IBM course id" do
        course_cross_checking(:account_name=>"ibm",:user_name=>"ibm.s1@arrivusystems.com",:course_id=>ibm_course_s3.id,:access_type=>"change course id")
      end

      it "should show unauthorized message when IBM's Sub Account2 admin tried to accessing IBM's Sub Account1's course by giving IBM course id" do
        course_cross_checking(:account_name=>"ibm",:user_name=>"ibm.s2@arrivusystems.com",:course_id=>ibm_course_s1.id,:access_type=>"change course id")
      end

      it "should show unauthorized message when TCS's Sub Account1 admin tried to accessing TCS's Main Account's course by giving TCS course id" do
        course_cross_checking(:account_name=>"tcs",:user_name=>"tcs.s1@arrivusystems.com",:course_id=>tcs_course_m1.id,:access_type=>"change course id")
      end

      it "should show unauthorized message when TCS's Sub Account2 admin tried to accessing TCS's Main Account's course by giving TCS course id" do
        course_cross_checking(:account_name=>"tcs",:user_name=>"tcs.s2@arrivusystems.com",:course_id=>tcs_course_m1.id,:access_type=>"change course id")
      end

      it "should show unauthorized message when TCS's Sub Account1 admin tried to accessing TCS's Sub Account2's course by giving TCS course id" do
        course_cross_checking(:account_name=>"tcs",:user_name=>"tcs.s1@arrivusystems.com",:course_id=>tcs_course_s3.id,:access_type=>"change course id")
      end

      it "should show unauthorized message when TCS's Sub Account2 admin tried to accessing TCS's Sub Account1's course by giving TCS course id" do
        course_cross_checking(:account_name=>"tcs",:user_name=>"tcs.s2@arrivusystems.com",:course_id=>tcs_course_s1.id,:access_type=>"change course id")
      end

      it "should ask for login when IBM's sub account1 admin tried to acccessing TCS sub account1's course by giving TCS url" do
        course_cross_checking(:account_name=>"ibm",:user_name=>"ibm.s1@arrivusystems.com",:cross_account_name=>"tcs",:course_id=>tcs_course_s1.id,:access_type=>"change url")
      end

      it "should ask for login when IBM's sub account2 admin tried to acccessing TCS sub account2's course by giving TCS url" do
        course_cross_checking(:account_name=>"ibm",:user_name=>"ibm.s2@arrivusystems.com",:cross_account_name=>"tcs",:course_id=>tcs_course_s3.id,:access_type=>"change url")
      end

      it "should ask for login when TCS's sub account1 admin tried to acccessing IBM sub account1's course by giving IBM url" do
        course_cross_checking(:account_name=>"tcs",:user_name=>"tcs.s1@arrivusystems.com",:cross_account_name=>"ibm",:course_id=>ibm_course_s1.id,:access_type=>"change url")
      end

      it "should ask for login when TCS's sub account2 admin tried to acccessing IBM sub account2's course by giving IBM url" do
        course_cross_checking(:account_name=>"tcs",:user_name=>"tcs.s2@arrivusystems.com",:cross_account_name=>"ibm",:course_id=>ibm_course_s3.id,:access_type=>"change url")
      end


      # Student course check
      it "should login as a Student in TCS domain" do
        course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st1@arrivusystems.com",
                                    :course_id=>[tcs_course_ms1.id,tcs_course_s1.id,tcs_course_m1.id],:user_role=>"student")

        course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st2@arrivusystems.com",
                                   :course_id=>[tcs_course_ms1.id,tcs_course_s2.id,tcs_course_m1.id],:user_role=>"student")

        course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st3@arrivusystems.com",
                                   :course_id=>[tcs_course_ms1.id,tcs_course_s3.id,tcs_course_m1.id],:user_role=>"student")

        course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st4@arrivusystems.com",
                                   :course_id=>[tcs_course_ms2.id,tcs_course_s4.id,tcs_course_m2.id],:user_role=>"student")

        course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st5@arrivusystems.com",
                                   :course_id=>[tcs_course_ms2.id,tcs_course_s1.id,tcs_course_m2.id],:user_role=>"student")


      end

      # Teacher course check

      it "should login as a Teacher in TCS domain" do
        course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",
                                   :course_id=>[tcs_course_ms1.id,tcs_course_s1.id,tcs_course_m1.id],:user_role=>"teacher")

        course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr2@arrivusystems.com",
                                   :course_id=>[tcs_course_ms1.id,tcs_course_s2.id,tcs_course_m1.id],:user_role=>"teacher")

        course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr3@arrivusystems.com",
                                   :course_id=>[tcs_course_ms1.id,tcs_course_s3.id,tcs_course_m1.id],:user_role=>"teacher")

        course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr4@arrivusystems.com",
                                   :course_id=>[tcs_course_ms2.id,tcs_course_s4.id,tcs_course_m2.id],:user_role=>"teacher")

        course_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr5@arrivusystems.com",
                                   :course_id=>[tcs_course_ms2.id,tcs_course_s1.id,tcs_course_m2.id],:user_role=>"teacher")


      end

      #student cross check with in the same domain

      it "Should show unauthorized message when a IBM Student1 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",:course_id=>[ibm_course_s2.id,ibm_course_s3.id,ibm_course_s4.id,ibm_course_m2.id,ibm_course_ms2.id],:access_type=>"change course id")
      end

      it "Should show unauthorized message when a IBM Student2 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",:course_id=>[ibm_course_s1.id,ibm_course_s3.id,ibm_course_s4.id,ibm_course_m2.id,ibm_course_ms2.id],:access_type=>"change course id")
      end

      it "Should show unauthorized message when a IBM Student3 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",:course_id=>[ibm_course_s2.id,ibm_course_s1.id,ibm_course_s4.id,ibm_course_m2.id,ibm_course_ms2.id],:access_type=>"change course id")
      end

      it "Should show unauthorized message when a IBM Student4 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st4@arrivusystems.com",:course_id=>[ibm_course_s2.id,ibm_course_s3.id,ibm_course_s1.id,ibm_course_m1.id,ibm_course_ms1.id],:access_type=>"change course id")
      end

      it "Should show unauthorized message when a IBM Student5 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st5@arrivusystems.com",:course_id=>[ibm_course_s2.id,ibm_course_s3.id,ibm_course_s4.id,ibm_course_m1.id,ibm_course_ms1.id],:access_type=>"change course id")
      end



      it "Should show unauthorized message when a TCS Student1 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st1@arrivusystems.com",:course_id=>[tcs_course_s2.id,tcs_course_s3.id,tcs_course_s4.id,tcs_course_m2.id,tcs_course_ms2.id],:access_type=>"change course id")
      end

      it "Should show unauthorized message when a TCS Student2 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st2@arrivusystems.com",:course_id=>[tcs_course_s1.id,tcs_course_s3.id,tcs_course_s4.id,tcs_course_m2.id,tcs_course_ms2.id],:access_type=>"change course id")
      end

      it "Should show unauthorized message when a TCS Student3 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st3@arrivusystems.com",:course_id=>[tcs_course_s2.id,tcs_course_s1.id,tcs_course_s4.id,tcs_course_m2.id,tcs_course_ms2.id],:access_type=>"change course id")
      end

      it "Should show unauthorized message when a TCS Student4 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st4@arrivusystems.com",:course_id=>[tcs_course_s2.id,tcs_course_s3.id,tcs_course_s1.id,tcs_course_m1.id,tcs_course_ms1.id],:access_type=>"change course id")
      end

      it "Should show unauthorized message when a TCS Student5 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st5@arrivusystems.com",:course_id=>[tcs_course_s2.id,tcs_course_s3.id,tcs_course_s4.id,tcs_course_m1.id,tcs_course_ms1.id],:access_type=>"change course id")
      end

      #student cross check with different domain

      it "Should ask for login when a IBM Student1 try to access TCS student1's course giving course url" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st1@arrivusystems.com",:checking_account_name=>"tcs",:course_id=>[tcs_course_s2.id,tcs_course_s3.id,tcs_course_s4.id,tcs_course_m2.id,tcs_course_ms2.id],:access_type=>"change url")
      end

      it "Should ask for login when a IBM Student2 try to access TCS student2's course giving course url" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st2@arrivusystems.com",:checking_account_name=>"tcs",:course_id=>[tcs_course_s1.id,tcs_course_s3.id,tcs_course_s4.id,tcs_course_m2.id,tcs_course_ms2.id],:access_type=>"change url")
      end

      it "Should ask for login when a IBM Student3 try to access TCS student3's course giving course url" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st3@arrivusystems.com",:checking_account_name=>"tcs",:course_id=>[tcs_course_s2.id,tcs_course_s1.id,tcs_course_s4.id,tcs_course_m2.id,tcs_course_ms2.id],:access_type=>"change url")
      end

      it "Should ask for login when a IBM Student4 try to access TCS student4's course giving course url" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st4@arrivusystems.com",:checking_account_name=>"tcs",:course_id=>[tcs_course_s2.id,tcs_course_s3.id,tcs_course_s1.id,tcs_course_m1.id,tcs_course_ms1.id],:access_type=>"change url")
      end

      it "Should ask for login when a IBM Student5 try to access TCS student5's course giving course url" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.st5@arrivusystems.com",:checking_account_name=>"tcs",:course_id=>[tcs_course_s2.id,tcs_course_s3.id,tcs_course_s4.id,tcs_course_m1.id,tcs_course_ms1.id],:access_type=>"change url")
      end





      it "Should ask for login when a TCS Student1 try to access IBM student1's course giving course url" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st1@arrivusystems.com",:checking_account_name=>"ibm",:course_id=>[ibm_course_s2.id,ibm_course_s3.id,ibm_course_s4.id,ibm_course_m2.id,ibm_course_ms2.id],:access_type=>"change url")
      end

      it "Should ask for login when a TCS Student2 try to access IBM student2's course giving course url" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st2@arrivusystems.com",:checking_account_name=>"ibm",:course_id=>[ibm_course_s1.id,ibm_course_s3.id,ibm_course_s4.id,ibm_course_m2.id,ibm_course_ms2.id],:access_type=>"change url")
      end

      it "Should ask for login when a TCS Student3 try to access IBM student3's course giving course url" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st3@arrivusystems.com",:checking_account_name=>"ibm",:course_id=>[ibm_course_s2.id,ibm_course_s1.id,ibm_course_s4.id,ibm_course_m2.id,ibm_course_ms2.id],:access_type=>"change url")
      end

      it "Should ask for login when a TCS Student4 try to access IBM student4's course giving course url" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st4@arrivusystems.com",:checking_account_name=>"ibm",:course_id=>[ibm_course_s2.id,ibm_course_s3.id,ibm_course_s1.id,ibm_course_m1.id,ibm_course_ms1.id],:access_type=>"change url")
      end

      it "Should ask for login when a TCS Student5 try to access IBM student5's course giving course url" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.st5@arrivusystems.com",:checking_account_name=>"ibm",:course_id=>[ibm_course_s2.id,ibm_course_s3.id,ibm_course_s4.id,ibm_course_m1.id,ibm_course_ms1.id],:access_type=>"change url")
      end


      #teacher cross check with in the same domain

      it "Should show unauthorized message when a IBM Teacher1 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",:course_id=>[ibm_course_s2.id,ibm_course_s3.id,ibm_course_s4.id,ibm_course_ms2.id],:access_type=>"change course id")
      end

      it "Should show unauthorized message when a IBM Teacher2 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",:course_id=>[ibm_course_s1.id,ibm_course_s3.id,ibm_course_s4.id,ibm_course_m2.id,ibm_course_ms2.id],:access_type=>"change course id")
      end

      it "Should show unauthorized message when a IBM Teacher3 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",:course_id=>[ibm_course_s2.id,ibm_course_s1.id,ibm_course_s4.id,ibm_course_m2.id,ibm_course_ms2.id],:access_type=>"change course id")
      end

      it "Should show unauthorized message when a IBM Teacher4 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr4@arrivusystems.com",:course_id=>[ibm_course_s2.id,ibm_course_s3.id,ibm_course_s1.id,ibm_course_m1.id,ibm_course_ms1.id],:access_type=>"change course id")
      end

      it "Should show unauthorized message when a IBM Teacher5 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr5@arrivusystems.com",:course_id=>[ibm_course_s2.id,ibm_course_s3.id,ibm_course_s4.id,ibm_course_m1.id,ibm_course_ms1.id],:access_type=>"change course id")
      end



      it "Should show unauthorized message when a TCS Teacher1 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",:course_id=>[tcs_course_s2.id,tcs_course_s3.id,tcs_course_s4.id,tcs_course_ms2.id],:access_type=>"change course id")
      end

      it "Should show unauthorized message when a TCS Teacher2 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr2@arrivusystems.com",:course_id=>[tcs_course_s1.id,tcs_course_s3.id,tcs_course_s4.id,tcs_course_m2.id,tcs_course_ms2.id],:access_type=>"change course id")
      end

      it "Should show unauthorized message when a TCS Teacher3 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr3@arrivusystems.com",:course_id=>[tcs_course_s2.id,tcs_course_s1.id,tcs_course_s4.id,tcs_course_m2.id,tcs_course_ms2.id],:access_type=>"change course id")
      end

      it "Should show unauthorized message when a TCS Teacher4 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr4@arrivusystems.com",:course_id=>[tcs_course_s2.id,tcs_course_s3.id,tcs_course_s1.id,tcs_course_m1.id,tcs_course_ms1.id],:access_type=>"change course id")
      end

      it "Should show unauthorized message when a TCS Teacher5 try to access a course whose is not part of the course by giving course id" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr5@arrivusystems.com",:course_id=>[tcs_course_s2.id,tcs_course_s3.id,tcs_course_s4.id,tcs_course_m1.id,tcs_course_ms1.id],:access_type=>"change course id")
      end

      #teacher cross check with different domain

      it " Should ask for login when a IBM Teacher1 try to access TCS student1's course giving course url" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",:checking_account_name=>"tcs",:course_id=>[tcs_course_s2.id,tcs_course_s3.id,tcs_course_s4.id,tcs_course_m2.id,tcs_course_ms2.id],:access_type=>"change url")
      end

      it "Should ask for login when a IBM Teacher2 try to access TCS student2's course giving course url" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr2@arrivusystems.com",:checking_account_name=>"tcs",:course_id=>[tcs_course_s1.id,tcs_course_s3.id,tcs_course_s4.id,tcs_course_m2.id,tcs_course_ms2.id],:access_type=>"change url")
      end

      it "Should ask for login when a IBM Teacher3 try to access TCS student3's course giving course url" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr3@arrivusystems.com",:checking_account_name=>"tcs",:course_id=>[tcs_course_s2.id,tcs_course_s1.id,tcs_course_s4.id,tcs_course_m2.id,tcs_course_ms2.id],:access_type=>"change url")
      end

      it "Should ask for login when a IBM Teacher4 try to access TCS student4's course giving course url" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr4@arrivusystems.com",:checking_account_name=>"tcs",:course_id=>[tcs_course_s2.id,tcs_course_s3.id,tcs_course_s1.id,tcs_course_m1.id,tcs_course_ms1.id],:access_type=>"change url")
      end

      it "Should ask for login when a IBM Teacher5 try to access TCS student5's course giving course url" do
        course_cross_check_by_user(:account_name=>"ibm",:user_name=>"ibm.tr5@arrivusystems.com",:checking_account_name=>"tcs",:course_id=>[tcs_course_s2.id,tcs_course_s3.id,tcs_course_s4.id,tcs_course_m1.id,tcs_course_ms1.id],:access_type=>"change url")
      end





      it "Should ask for login when a TCS Teacher1 try to access IBM student1's course giving course url" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",:checking_account_name=>"ibm",:course_id=>[ibm_course_s2.id,ibm_course_s3.id,ibm_course_s4.id,ibm_course_m2.id,ibm_course_ms2.id],:access_type=>"change url")
      end

      it "Should ask for login when a TCS Teacher2 try to access IBM student2's course giving course url" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr2@arrivusystems.com",:checking_account_name=>"ibm",:course_id=>[ibm_course_s1.id,ibm_course_s3.id,ibm_course_s4.id,ibm_course_m2.id,ibm_course_ms2.id],:access_type=>"change url")
      end

      it "Should ask for login when a TCS Teacher3 try to access IBM student3's course giving course url" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr3@arrivusystems.com",:checking_account_name=>"ibm",:course_id=>[ibm_course_s2.id,ibm_course_s1.id,ibm_course_s4.id,ibm_course_m2.id,ibm_course_ms2.id],:access_type=>"change url")
      end

      it " Should ask for login when a TCS Teacher4 try to access IBM student4's course giving course url" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr4@arrivusystems.com",:checking_account_name=>"ibm",:course_id=>[ibm_course_s2.id,ibm_course_s3.id,ibm_course_s1.id,ibm_course_m1.id,ibm_course_ms1.id],:access_type=>"change url")
      end

      it "Should ask for login when a TCS Teacher5 try to access IBM student5's course giving course url" do
        course_cross_check_by_user(:account_name=>"tcs",:user_name=>"tcs.tr5@arrivusystems.com",:checking_account_name=>"ibm",:course_id=>[ibm_course_s2.id,ibm_course_s3.id,ibm_course_s4.id,ibm_course_m1.id,ibm_course_ms1.id],:access_type=>"change url")
      end





      #Teacher as a student course check in the same domain

      it "should show the course page without editing options when a teacher enrolled as a student in other courses of same domain" do
        teacher_as_a_student(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",:course_id=>ibm_course_m2.id)

      end

      it "should show the course page without editing options when a teacher enrolled as a student in other courses of same domain" do
        teacher_as_a_student(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",:course_id=>tcs_course_m2.id)

      end

      it "should show the course page without editing options when a teacher enrolled as a student in other courses of other domain" do
        teacher_as_a_student(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",:course_id=>tcs_course_m1.id)

      end

      it "should show the course page without editing options when a teacher enrolled as a student in other courses of other domain" do
        teacher_as_a_student(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",:course_id=>ibm_course_m1.id)

      end



    end





require File.expand_path(File.dirname(__FILE__) + '/common_mt')
require File.expand_path(File.dirname(__FILE__) + '/data_setup_for_groups')



describe "groups_cross_checking" do

  it_should_behave_like "in-process server selenium tests"

    def view_group(params={})
      driver.manage().window().maximize()
      params[:user_name].each do |user_name|
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
        fill_in_login_form(user_name,"Admin123$")
        wait_for_ajaximations
        f('.user_name').text.should == user_name
        group=params[:group]
        course=Course.find(group.context_id)
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course.id}/groups"
        wait_for_ajaximations
        f("#section-tabs-header").text.should include_text course.course_code
        if params[:user_role]== "student"
          f(".group_name").text.should include_text group.name
          fj("a:contains('Start a New Group')").should be_displayed
          fj(".toggle_members_link").click
          wait_for_ajaximations
          params[:group_members].each do |group_member_name|
            f(".member_list").text.should include_text group_member_name
          end
        elsif params[:user_role]=="teacher" || params[:user_role]=="admin"
          #f(".left_side").text.should include_text group.name
          wait_for_ajaximations
          fj("#group_#{group.id}").text.should include_text group.name
          params[:group_members].each do |group_member_name|
            wait_for_ajaximations
            fj("#group_#{group.id}").text.should include_text group.name
          end
          fj("a:contains(' Make a New Set of Groups')").should be_displayed
        end
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/groups/#{group.id}"
        f("#section-tabs-header").text.should include_text group.name
        f("#section-tabs-header-subtitle").text.should include_text course.name
        fj("a:contains('New Announcement')").should be_displayed
        f(".recent-activity-header").text.should include_text "Recent Activity in #{group.name}"
        expect_new_page_load { f('.logout > a').click }
      end
    end

  def login_page_error_message
    driver.find_element(:id,"login_form").should be_displayed
    f("#flash_message_holder").text.should include_text "You must be logged in to access this page"
    driver.find_element(:id,"pseudonym_session_unique_id").should be_displayed
    driver.find_element(:id,"pseudonym_session_password").should be_displayed
  end
  def groups_cross_check(params={})
    driver.manage().window().maximize()
    params[:user_name].each do |user_name|
      driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
      fill_in_login_form(user_name,"Admin123$")
      wait_for_ajaximations
      f('.user_name').text.should == user_name
      params[:groups].each do |group|
        course=Course.find(group.context_id)
        if params[:access_type]=="change id"
          driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course.id}/groups"
          unauthorized_warning_message
          driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
          wait_for_ajaximations
          driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/groups/#{group.id}"
          wait_for_ajaximations
          unauthorized_warning_message
        elsif params[:access_type]=="change url"
          driver.get "http://#{params[:checking_account_name]}.lvh.me:#{$server_port}/courses/#{course.id}/groups"
          login_page_error_message
          driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
          wait_for_ajaximations
          driver.get "http://#{params[:checking_account_name]}.lvh.me:#{$server_port}/groups/#{group.id}"
          login_warning_message
          driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
        end
      end
      expect_new_page_load { f('.logout > a').click }
    end
  end


  ### Ibm domain group members viewing their groups

    it "should allow to view the group when Ibm course1's group1's students try to view the group" do
       view_group(:account_name=>"ibm",:user_name=>["ibm.st1@arrivusystems.com","ibm.st2@arrivusystems.com"],:group=>ibm_course1_group1,
                  :user_role=>"student",:group_members=>["ibm.st1@arrivusystems.com","ibm.st2@arrivusystems.com","ibm.tr1@arrivusystems.com"])
    end

    it "should allow to view the group when Ibm course1's group2's students try to view the group" do
      view_group(:account_name=>"ibm",:user_name=>["ibm.st3@arrivusystems.com","ibm.st4@arrivusystems.com"],:group=>ibm_course1_group2,
                 :user_role=>"student",:group_members=>["ibm.st3@arrivusystems.com","ibm.st4@arrivusystems.com","ibm.tr2@arrivusystems.com"])
    end


    it "should allow to view the group when Ibm course2's group1's students try to view the group" do
       view_group(:account_name=>"ibm",:user_name=>["ibm.st5@arrivusystems.com","ibm.st6@arrivusystems.com"],:group=>ibm_course2_group1,
                  :user_role=>"student",:group_members=>["ibm.st5@arrivusystems.com","ibm.st6@arrivusystems.com","ibm.tr3@arrivusystems.com"])
    end

    it "should allow to view the group when Ibm course2's group2's students try to view the group" do
      view_group(:account_name=>"ibm",:user_name=>["ibm.st7@arrivusystems.com","ibm.st8@arrivusystems.com"],:group=>ibm_course2_group2,
                 :user_role=>"student",:group_members=>["ibm.st7@arrivusystems.com","ibm.st8@arrivusystems.com","ibm.tr4@arrivusystems.com"])
    end


    ##### Tcs domain group members viewing their group

      it "should allow to view the group when tcs course1's group1's students try to view the group" do

         view_group(:account_name=>"tcs",:user_name=>["tcs.st1@arrivusystems.com","tcs.st2@arrivusystems.com"],:group=>tcs_course1_group1,
                    :user_role=>"student",:group_members=>["tcs.st1@arrivusystems.com","tcs.st2@arrivusystems.com","tcs.tr1@arrivusystems.com"])
      end

      it "should allow to view the group when tcs course1's group2's students try to view the group" do
        view_group(:account_name=>"tcs",:user_name=>["tcs.st3@arrivusystems.com","tcs.st4@arrivusystems.com"],:group=>tcs_course1_group2,
                   :user_role=>"student",:group_members=>["tcs.st3@arrivusystems.com","tcs.st4@arrivusystems.com","tcs.tr2@arrivusystems.com"])
      end


      it "should allow to view the group when tcs course2's group1's students try to view the group" do
        view_group(:account_name=>"tcs",:user_name=>["tcs.st5@arrivusystems.com","tcs.st6@arrivusystems.com"],:group=>tcs_course2_group1,
                   :user_role=>"student",:group_members=>["tcs.st5@arrivusystems.com","tcs.st6@arrivusystems.com","tcs.tr3@arrivusystems.com"])
      end

      it "should allow to view the group when tcs course2's group2's students try to view the group" do
        view_group(:account_name=>"tcs",:user_name=>["tcs.st7@arrivusystems.com","tcs.st8@arrivusystems.com"],:group=>tcs_course2_group2,
                   :user_role=>"student",:group_members=>["tcs.st7@arrivusystems.com","tcs.st8@arrivusystems.com","tcs.tr4@arrivusystems.com"])
      end

  ###### Ibm teachers viewing their group page

      it "should allow to view the group when Ibm teacher1 try to view the group" do
        view_group(:account_name=>"ibm",:user_name=>["ibm.tr1@arrivusystems.com"],:group=>ibm_course1_group1,:user_role=>"teacher",
                   :group_members=>["ibm.st1@arrivusystems.com","ibm.st2@arrivusystems.com","ibm.tr1@arrivusystems.com"])
      end

      it "should allow to view the group when Ibm teacher2 try to view the group" do
        view_group(:account_name=>"ibm",:user_name=>["ibm.tr2@arrivusystems.com"],:group=>ibm_course1_group2,:user_role=>"teacher",
                   :group_members=>["ibm.st3@arrivusystems.com","ibm.st4@arrivusystems.com","ibm.tr2@arrivusystems.com"])
      end

        it "should allow to view the group when Ibm teacher3 try to view the group" do
          view_group(:account_name=>"ibm",:user_name=>["ibm.tr3@arrivusystems.com"],:group=>ibm_course2_group1,:user_role=>"teacher",
                     :group_members=>["ibm.st5@arrivusystems.com","ibm.st6@arrivusystems.com","ibm.tr3@arrivusystems.com"])
        end

        it "should allow to view the group when Ibm teacher4 try to view the group" do
          view_group(:account_name=>"ibm",:user_name=>["ibm.tr4@arrivusystems.com"],:group=>ibm_course2_group2,:user_role=>"teacher",
                     :group_members=>["ibm.st7@arrivusystems.com","ibm.st8@arrivusystems.com","ibm.tr4@arrivusystems.com"])
        end

  ##### TCS teachers viewing their group page

  it "should allow to view the group when tcs teacher1 try to view the group" do
    view_group(:account_name=>"tcs",:user_name=>["tcs.tr1@arrivusystems.com"],:group=>tcs_course1_group1,:user_role=>"teacher",
               :group_members=>["tcs.st1@arrivusystems.com","tcs.st2@arrivusystems.com","tcs.tr1@arrivusystems.com"])
  end

  it "should allow to view the group when tcs teacher2 try to view the group" do
    view_group(:account_name=>"tcs",:user_name=>["tcs.tr2@arrivusystems.com"],:group=>tcs_course1_group2,:user_role=>"teacher",
               :group_members=>["tcs.st3@arrivusystems.com","tcs.st4@arrivusystems.com","tcs.tr2@arrivusystems.com"])
  end

  it "should allow to view the group when tcs teacher3 try to view the group" do
    view_group(:account_name=>"tcs",:user_name=>["tcs.tr3@arrivusystems.com"],:group=>tcs_course2_group1,:user_role=>"teacher",
               :group_members=>["tcs.st5@arrivusystems.com","tcs.st6@arrivusystems.com","tcs.tr3@arrivusystems.com"])
  end

  it "should allow to view the group when tcs teacher4 try to view the group" do
    view_group(:account_name=>"tcs",:user_name=>["tcs.tr4@arrivusystems.com"],:group=>tcs_course2_group2,:user_role=>"teacher",
               :group_members=>["tcs.st7@arrivusystems.com","tcs.st8@arrivusystems.com","tcs.tr4@arrivusystems.com"])
  end


  ##### Ibm admin going to view their group

  it "should allow to view the group when Ibm Admin try to view ibm course1's groups" do
      view_group(:account_name=>"ibm",:user_name=>["ibm@arrivusystems.com"],:group=>ibm_course1_group1, :user_role=>"admin",
               :group_members=>["ibm.st1@arrivusystems.com","ibm.st2@arrivusystems.com","ibm.tr1@arrivusystems.com"])
      view_group(:account_name=>"ibm",:user_name=>["ibm@arrivusystems.com"],:group=>ibm_course1_group2, :user_role=>"admin",
                 :group_members=>["ibm.st3@arrivusystems.com","ibm.st4@arrivusystems.com","ibm.tr2@arrivusystems.com"])
      view_group(:account_name=>"ibm",:user_name=>["ibm@arrivusystems.com"],:group=>ibm_course2_group1, :user_role=>"admin",
                 :group_members=>["ibm.st5@arrivusystems.com","ibm.st6@arrivusystems.com","ibm.tr3@arrivusystems.com"])
      view_group(:account_name=>"ibm",:user_name=>["ibm@arrivusystems.com"],:group=>ibm_course2_group2, :user_role=>"admin",
                 :group_members=>["ibm.st7@arrivusystems.com","ibm.st8@arrivusystems.com","ibm.tr4@arrivusystems.com"])
  end

  it "should allow to view the group when tcs Admin try to view tcs course1's groups" do
    view_group(:account_name=>"tcs",:user_name=>["tcs@arrivusystems.com"],:group=>tcs_course1_group1, :user_role=>"admin",
               :group_members=>["tcs.st1@arrivusystems.com","tcs.st2@arrivusystems.com","tcs.tr1@arrivusystems.com"])
    view_group(:account_name=>"tcs",:user_name=>["tcs@arrivusystems.com"],:group=>tcs_course1_group2, :user_role=>"admin",
               :group_members=>["tcs.st3@arrivusystems.com","tcs.st4@arrivusystems.com","tcs.tr2@arrivusystems.com"])
    view_group(:account_name=>"tcs",:user_name=>["tcs@arrivusystems.com"],:group=>tcs_course2_group1, :user_role=>"admin",
               :group_members=>["tcs.st5@arrivusystems.com","tcs.st6@arrivusystems.com","tcs.tr3@arrivusystems.com"])
    view_group(:account_name=>"tcs",:user_name=>["tcs@arrivusystems.com"],:group=>tcs_course2_group2, :user_role=>"admin",
               :group_members=>["tcs.st7@arrivusystems.com","tcs.st8@arrivusystems.com","tcs.tr4@arrivusystems.com"])
  end

  #### Admin cross check (domain to damain)

  it "show unauthorized message when an ibm admin try to access tcs group by changing group id" do
    groups_cross_check(:account_name=>"ibm",:user_name=>["ibm@arrivusystems.com"],:groups=>[tcs_course1_group1,tcs_course1_group2,
                       tcs_course2_group1,tcs_course2_group2],:checking_account_name=>"tcs",:access_type=>"change id")
  end

  it "show unauthorized message when an ibm admin try to access tcs group by changing whole url" do
    groups_cross_check(:account_name=>"ibm",:user_name=>["ibm@arrivusystems.com"],:groups=>[tcs_course1_group1,tcs_course1_group2,
                        tcs_course2_group1,tcs_course2_group2],:checking_account_name=>"tcs",:access_type=>"change url")
  end

  it "show unauthorized message when an tcs admin try to access ibm group by changing group id" do
    groups_cross_check(:account_name=>"tcs",:user_name=>["tcs@arrivusystems.com"],:groups=>[ibm_course1_group1,ibm_course1_group2,
                        ibm_course2_group1,ibm_course2_group2],:checking_account_name=>"ibm",:access_type=>"change id")
  end

  it "show unauthorized message when an tcs admin try to access ibm group by changing group id" do
    groups_cross_check(:account_name=>"tcs",:user_name=>["tcs@arrivusystems.com"],:groups=>[ibm_course1_group1,ibm_course1_group2,
                       ibm_course2_group1,ibm_course2_group2],:checking_account_name=>"ibm",:access_type=>"change url")
  end

  #### Cross checking for teacher in same domain

  it "show unauthorized message when an ibm teachers try to access ibm's course group by changing group id, with out enrollment" do
    groups_cross_check(:account_name=>"ibm",:user_name=>["ibm.tr1@arrivusystems.com","ibm.tr2@arrivusystems.com",],:groups=>[ibm_course2_group1,ibm_course2_group2],
                       :access_type=>"change id")
    groups_cross_check(:account_name=>"ibm",:user_name=>["ibm.tr3@arrivusystems.com","ibm.tr4@arrivusystems.com",],:groups=>[ibm_course1_group1,ibm_course1_group2],
                       :access_type=>"change id")
  end


  it "show unauthorized message when an tcs teachers try to access tcs's course group by changing group id, with out enrollment" do
    groups_cross_check(:account_name=>"tcs",:user_name=>["tcs.tr1@arrivusystems.com","tcs.tr2@arrivusystems.com",],:groups=>[tcs_course2_group1,tcs_course2_group2],
                       :access_type=>"change id")
    groups_cross_check(:account_name=>"tcs",:user_name=>["tcs.tr3@arrivusystems.com","tcs.tr4@arrivusystems.com",],:groups=>[tcs_course1_group1,tcs_course1_group2],
                       :access_type=>"change id")

  end

  #########  cross checking for teachers from domain to domain

  it "show unauthorized message when an ibm teachers try to access ibm's course group by changing group id, with out enrollment" do
    groups_cross_check(:account_name=>"ibm",:user_name=>["ibm.tr1@arrivusystems.com","ibm.tr2@arrivusystems.com","ibm.tr3@arrivusystems.com","ibm.tr4@arrivusystems.com"],
                       :groups=>[tcs_course1_group1,tcs_course1_group2,tcs_course2_group1,tcs_course2_group2],:access_type=>"change url",:checking_account_name=>"tcs")

  end

  it "show unauthorized message when an tcs teachers try to access tcs's course group by changing group id, with out enrollment" do
    groups_cross_check(:account_name=>"tcs",:user_name=>["tcs.tr1@arrivusystems.com","tcs.tr2@arrivusystems.com","tcs.tr3@arrivusystems.com","tcs.tr4@arrivusystems.com"],
                       :groups=>[ibm_course1_group1,ibm_course1_group2,ibm_course2_group1,ibm_course2_group2],:access_type=>"change url",:checking_account_name=>"ibm")

  end

  ####### IBM Students viewing groups cross checking

  it "show unauthorized message when an ibm students try to access ibm's course group by changing group id, with out enrollment" do
    groups_cross_check(:account_name=>"ibm",:user_name=>["ibm.st1@arrivusystems.com","ibm.st2@arrivusystems.com","ibm.st3@arrivusystems.com","ibm.st4@arrivusystems.com"],
                       :groups=>[tcs_course1_group1,tcs_course1_group2,tcs_course2_group1,tcs_course2_group2],:access_type=>"change url",:checking_account_name=>"tcs")

  end

  it "show unauthorized message when an tcs students try to access tcs's course group by changing group id, with out enrollment" do
    groups_cross_check(:account_name=>"tcs",:user_name=>["tcs.st1@arrivusystems.com","tcs.st2@arrivusystems.com","tcs.st3@arrivusystems.com","tcs.st4@arrivusystems.com"],
                       :groups=>[ibm_course1_group1,ibm_course1_group2,ibm_course2_group1,ibm_course2_group2],:access_type=>"change url",:checking_account_name=>"ibm")

  end




end


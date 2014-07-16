require File.expand_path(File.dirname(__FILE__) + '/common_mt')
require File.expand_path(File.dirname(__FILE__) + '/data_setup')

describe "Announcement_Cross_Check_Creation" do

  it_should_behave_like "in-process server selenium tests"


  def discussion_check_by_admin(params={})
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form(params[:user_name],"Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == params[:user_name]
    params[:discussion_topic_ids].each do |discussion_topic_id|
      discussion_topic_details=DiscussionTopic.find(discussion_topic_id)
      course=Course.find(discussion_topic_details.context_id)
      author_name=User.find(discussion_topic_details.user_id).name
      driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course.id}/discussion_topics"
      f("#section-tabs-header").text.should include_text  course.course_code
      driver.find_element(:id,'new-discussion-btn').should be_displayed
      f('.title').should include_text discussion_topic_details.title
      driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course.id}/discussion_topics/#{discussion_topic_id}"
      wait_for_ajaximations
      f("#breadcrumbs").should include_text discussion_topic_details.title
      ('#content').should_not include_text(discussion_topic_details.title)
      f('.discussion-title').should include_text discussion_topic_details.title
      f('.author').should include_text author_name
      if params[:user_role]!="student"
        f('.icon-edit').should be_displayed
      end

    end
    expect_new_page_load { f('.logout > a').click }
  end

  def discussion_corss_check(params={})
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form(params[:user_name],"Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == params[:user_name]
    params[:discussion_topic_ids].each do |discussion_topic_id|
      discussion_topic_details=DiscussionTopic.find(discussion_topic_id)
      course=Course.find(discussion_topic_details.context_id)
      author_name=User.find(discussion_topic_details.user_id).name
      if params[:access_type]=="change course and discussion id only"
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course.id}/discussion_topics/#{discussion_topic_id}"
        driver.find_element(:id,"unauthorized_holder").should be_displayed
        driver.find_element(:id,"unauthorized_message").should be_displayed
        f('.ui-state-error').should include_text("Unauthorized")
      end

      if params[:access_type]=="change url"
        driver.get "http://#{params[:checking_account_name]}.lvh.me:#{$server_port}/courses/#{course.id}/discussion_topics/#{discussion_topic_id}"
        driver.find_element(:id,"login_form").should be_displayed
        driver.find_element(:id,"unauthorized_message").should be_displayed
        f('.ui-state-error').should include_text("Please Log In")
        driver.find_element(:id,"pseudonym_session_unique_id").should be_displayed
        driver.find_element(:id,"pseudonym_session_password").should be_displayed

      end

    end
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    expect_new_page_load { f('.logout > a').click }
  end



 ### Admin View discussions from their own doamin
 ##IBM Admin announcement check on their domain  success output


 it "should login as a IBM Admin and and view their course's discussion topics" do
    discussion_check_by_admin(:account_name=> "ibm",:user_name=>"ibm@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id,
                              ibm_course2_discussion_topic.id,ibm_course3_discussion_topic.id,ibm_course4_discussion_topic.id],:user_role=>"admin")
 end

 #TCS Admin announcement check on their domain

 it "should login as a TCS Admin and and view their course's discussion topics" do
    discussion_check_by_admin(:account_name=> "tcs",:user_name=>"tcs@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id,
                              tcs_course2_discussion_topic.id,tcs_course2_discussion_topic.id,tcs_course4_discussion_topic.id],:user_role=>"admin")
 end


 #### Cross Check by admin with out changing domain
 ##### by changing course and discussion id only
 it "should show unauthorized message when IBM Admin try to access TCS course's discussion topics with TCS course id and Discussion topic id" do
    discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id,
                              tcs_course2_discussion_topic.id,tcs_course2_discussion_topic.id,tcs_course4_discussion_topic.id],
                              :access_type=> "change course and discussion id only")
 end



 it "should show unauthorized message when TCS Admin try to access IBM course's discussion topics with IBM course id and Discussion topic id" do
    discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id,
                              ibm_course2_discussion_topic.id,ibm_course3_discussion_topic.id,ibm_course4_discussion_topic.id],
                              :access_type=> "change course and discussion id only")
 end

 #### Cross Check by admin with out changing domain
 ##### by changing whole url
 it "should show login page when IBM Admin try to access try TCS course's discussion topics by changing whole URL" do
    discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id,
                              tcs_course2_discussion_topic.id,tcs_course2_discussion_topic.id,tcs_course4_discussion_topic.id],
                              :access_type=> "change url", :checking_account_name=>"tcs")
 end



 it "should show login page when TCS Admin try to access try IBM course's discussion topics by changing whole URL" do
    discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id,
                              ibm_course2_discussion_topic.id,ibm_course3_discussion_topic.id,ibm_course4_discussion_topic.id],
                              :access_type=> "change url", :checking_account_name=>"ibm")
 end


 #### Teacher view their course's discussion topics
 it "should login as a IBM Teacher and and view their course's discussion topics" do
    discussion_check_by_admin(:account_name=> "ibm",:user_name=>"ibm.tr1@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id],:user_role=>"teacher")
    discussion_check_by_admin(:account_name=> "ibm",:user_name=>"ibm.tr2@arrivusystems.com",:discussion_topic_ids=>[ibm_course2_discussion_topic.id],:user_role=>"teacher")
    discussion_check_by_admin(:account_name=> "ibm",:user_name=>"ibm.tr3@arrivusystems.com",:discussion_topic_ids=>[ibm_course3_discussion_topic.id],:user_role=>"teacher")
 end

 it "should login as a TCS Teacher and and view their course's discussion topics" do
    discussion_check_by_admin(:account_name=> "tcs",:user_name=>"tcs.tr1@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id],:user_role=>"teacher")
    discussion_check_by_admin(:account_name=> "tcs",:user_name=>"tcs.tr2@arrivusystems.com",:discussion_topic_ids=>[tcs_course2_discussion_topic.id],:user_role=>"teacher")
    discussion_check_by_admin(:account_name=> "tcs",:user_name=>"tcs.tr3@arrivusystems.com",:discussion_topic_ids=>[tcs_course3_discussion_topic.id],:user_role=>"teacher")
 end

 #### IBM teachers viewing other course's discussion topics in ibm domain
 it "should show unauthorized message when a teacher is going to view the Discussion topic who is not part of its course in same domain" do
    discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.tr1@arrivusystems.com",:discussion_topic_ids=>[ibm_course3_discussion_topic.id],
                           :access_type=> "change course and discussion id only")
 end

 it "should show unauthorized message when a teacher is going to view the Discussion topic who is not part of its course in same domain" do
    discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.tr2@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id],
                           :access_type=> "change course and discussion id only")
 end

 it "should show unauthorized message when a teacher is going to view the Discussion topic who is not part of its course in same domain" do
    discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.tr3@arrivusystems.com",:discussion_topic_ids=>[ibm_course2_discussion_topic.id],
                           :access_type=> "change course and discussion id only")
 end



 #### TCS teachers viewing other course's discussion topics in tcs domain
 it "should show unauthorized message when a teacher is going to view the Discussion topic who is not part of its course in same domain" do
    discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.tr1@arrivusystems.com",:discussion_topic_ids=>[tcs_course3_discussion_topic.id],
                           :access_type=> "change course and discussion id only")
 end

 it "should show unauthorized message when a teacher is going to view the Discussion topic who is not part of its course in same domain" do
    discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.tr2@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id],
                           :access_type=> "change course and discussion id only")
 end

 it "should show unauthorized message when a teacher is going to view the Discussion topic who is not part of its course in same domain" do
    discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.tr3@arrivusystems.com",:discussion_topic_ids=>[tcs_course2_discussion_topic.id],
                           :access_type=> "change course and discussion id only")
 end


 #### IBM teachers viewing TCS course's discussion topics in tcs domain

 it "should show unauthorized message when IBM Teacher1 try to access TCS course's discussion topics with TCS course id and Discussion topic id" do
    discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.tr1@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id,
                 tcs_course2_discussion_topic.id,tcs_course2_discussion_topic.id],:access_type=> "change course and discussion id only")
 end

 it "should show unauthorized message when IBM Teacher2 try to access TCS course's discussion topics with TCS course id and Discussion topic id" do
    discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.tr1@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id,
                tcs_course2_discussion_topic.id,tcs_course2_discussion_topic.id],:access_type=> "change course and discussion id only")
 end

 it "should show unauthorized message when IBM Teacher3 try to access TCS course's discussion topics with TCS course id and Discussion topic id" do
    discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.tr1@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id,
                tcs_course2_discussion_topic.id,tcs_course2_discussion_topic.id],:access_type=> "change course and discussion id only")
 end

 #### TCS teachers viewing IBM course's discussion topics in ibm domain

 it "should show unauthorized message when TCS Teacher1 try to access IBM course's discussion topics with IBM course id and Discussion topic id" do
    discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.tr1@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id,
                  ibm_course2_discussion_topic.id,ibm_course2_discussion_topic.id],:access_type=> "change course and discussion id only")
 end

 it "should show unauthorized message when TCS Teacher2 try to access IBM course's discussion topics with IBM course id and Discussion topic id" do
    discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.tr1@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id,
                  ibm_course2_discussion_topic.id,ibm_course2_discussion_topic.id],:access_type=> "change course and discussion id only")
 end

 it "should show unauthorized message when TCS Teacher3 try to access IBM course's discussion topics with IBM course id and Discussion topic id" do
    discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.tr1@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id,
                  ibm_course2_discussion_topic.id,ibm_course2_discussion_topic.id],:access_type=> "change course and discussion id only")
 end


  #### IBM teachers viewing IBM course's discussion topics in ibm domain by changing whole url

  it "should show login page with warning message when IBM Teacher1 try to access TCS course's discussion topics by changing whole URL" do
    discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.tr1@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id,
                            tcs_course2_discussion_topic.id,tcs_course2_discussion_topic.id],:access_type=> "change url",:checking_account_name=>"tcs")
  end

  it "should show login page with warning message when IBM Teacher2 try to access TCS course's discussion topics by changing whole URL" do
    discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.tr1@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id,
                            tcs_course2_discussion_topic.id,tcs_course2_discussion_topic.id],:access_type=> "change url",:checking_account_name=>"tcs")
  end

  it "should show login page with warning message when IBM Teacher3 try to access TCS course's discussion topics by changing whole URL" do
    discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.tr1@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id,
                            tcs_course2_discussion_topic.id,tcs_course2_discussion_topic.id],:access_type=> "change url",:checking_account_name=>"tcs")
  end

  #### TCS teachers viewing IBM course's discussion topics in ibm domain by changing whole url

  it "should show show login page with warning message when TCS Teacher1 try to access IBM course's discussion topics by changing whole URL" do
    discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.tr1@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id,
                            ibm_course2_discussion_topic.id,ibm_course2_discussion_topic.id],:access_type=> "change url",:checking_account_name=>"ibm")
  end

  it "should show show login page with warning message when TCS Teacher2 try to access IBM course's discussion topics by changing whole URL" do
    discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.tr1@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id,
                            ibm_course2_discussion_topic.id,ibm_course2_discussion_topic.id],:access_type=> "change url",:checking_account_name=>"ibm")
  end

  it "should show show login page with warning message when TCS Teacher3 try to access IBM course's discussion topics by changing whole URL" do
    discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.tr1@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id,
                            ibm_course2_discussion_topic.id,ibm_course2_discussion_topic.id],:access_type=> "change url",:checking_account_name=>"ibm")
  end


  #### Student view their course's discussion topics
  it "should login as a IBM Student and and view their course's discussion topics" do
     discussion_check_by_admin(:account_name=> "ibm",:user_name=>"ibm.st1@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id],:user_role=>"student")
     discussion_check_by_admin(:account_name=> "ibm",:user_name=>"ibm.st2@arrivusystems.com",:discussion_topic_ids=>[ibm_course2_discussion_topic.id],:user_role=>"student")
     discussion_check_by_admin(:account_name=> "ibm",:user_name=>"ibm.st3@arrivusystems.com",:discussion_topic_ids=>[ibm_course3_discussion_topic.id],:user_role=>"student")
  end

  it "should login as a TCS Student and and view their course's discussion topics" do
     discussion_check_by_admin(:account_name=> "tcs",:user_name=>"tcs.st1@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id],:user_role=>"student")
     discussion_check_by_admin(:account_name=> "tcs",:user_name=>"tcs.st2@arrivusystems.com",:discussion_topic_ids=>[tcs_course2_discussion_topic.id],:user_role=>"student")
     discussion_check_by_admin(:account_name=> "tcs",:user_name=>"tcs.st3@arrivusystems.com",:discussion_topic_ids=>[tcs_course3_discussion_topic.id],:user_role=>"student")
  end




  #### IBM students viewing other course's discussion topics in ibm domain
  it "should show unauthorized message when a student is going to view the Discussion topic who is not part of its course in same domain" do
     discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.st1@arrivusystems.com",:discussion_topic_ids=>[ibm_course3_discussion_topic.id],
                            :access_type=> "change course and discussion id only")
  end

  it "should show unauthorized message when a student is going to view the Discussion topic who is not part of its course in same domain" do
     discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.st2@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id],
                            :access_type=> "change course and discussion id only")
  end

  it "should show unauthorized message when a student is going to view the Discussion topic who is not part of its course in same domain" do
     discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.st3@arrivusystems.com",:discussion_topic_ids=>[ibm_course2_discussion_topic.id],
                            :access_type=> "change course and discussion id only")
  end



  #### TCS students viewing other course's discussion topics in tcs domain
  it "should show unauthorized message when a student is going to view the Discussion topic who is not part of its course in same domain" do
     discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.st1@arrivusystems.com",:discussion_topic_ids=>[tcs_course3_discussion_topic.id],
                            :access_type=> "change course and discussion id only")
  end

  it "should show unauthorized message when a student is going to view the Discussion topic who is not part of its course in same domain" do
     discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.st2@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id],
                            :access_type=> "change course and discussion id only")
  end

  it "should show unauthorized message when a student is going to view the Discussion topic who is not part of its course in same domain" do
     discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.st3@arrivusystems.com",:discussion_topic_ids=>[tcs_course2_discussion_topic.id],
                            :access_type=> "change course and discussion id only")
  end


  #### IBM students viewing TCS course's discussion topics in tcs domain

  it "should show unauthorized message when IBM Student1 try to access TCS course's discussion topics with TCS course id and Discussion topic id" do
     discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.st1@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id,
                  tcs_course2_discussion_topic.id,tcs_course2_discussion_topic.id],:access_type=> "change course and discussion id only")
  end

  it "should show unauthorized message when IBM Student2 try to access TCS course's discussion topics with TCS course id and Discussion topic id" do
     discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.st1@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id,
                 tcs_course2_discussion_topic.id,tcs_course2_discussion_topic.id],:access_type=> "change course and discussion id only")
  end

  it "should show unauthorized message when IBM Student3 try to access TCS course's discussion topics with TCS course id and Discussion topic id" do
     discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.st1@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id,
                 tcs_course2_discussion_topic.id,tcs_course2_discussion_topic.id],:access_type=> "change course and discussion id only")
  end

  #### TCS students viewing IBM course's discussion topics in ibm domain

  it "should show unauthorized message when TCS Student1 try to access IBM course's discussion topics with IBM course id and Discussion topic id" do
     discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.st1@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id,
                   ibm_course2_discussion_topic.id,ibm_course2_discussion_topic.id],:access_type=> "change course and discussion id only")
  end

  it "should show unauthorized message when TCS Student2 try to access IBM course's discussion topics with IBM course id and Discussion topic id" do
     discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.st1@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id,
                   ibm_course2_discussion_topic.id,ibm_course2_discussion_topic.id],:access_type=> "change course and discussion id only")
  end

  it "should show unauthorized message when TCS Student3 try to access IBM course's discussion topics with IBM course id and Discussion topic id" do
     discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.st1@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id,
                   ibm_course2_discussion_topic.id,ibm_course2_discussion_topic.id],:access_type=> "change course and discussion id only")
  end


  #### IBM students viewing IBM course's discussion topics in ibm domain by changing whole url

  it "should show login page with warning message when IBM Student1 try to access TCS course's discussion topics by changing whole URL" do
    discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.st1@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id,
                            tcs_course2_discussion_topic.id,tcs_course2_discussion_topic.id],:access_type=> "change url",:checking_account_name=>"tcs")
  end

  it "should show login page with warning message when IBM Student2 try to access TCS course's discussion topics by changing whole URL" do
    discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.st1@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id,
                            tcs_course2_discussion_topic.id,tcs_course2_discussion_topic.id],:access_type=> "change url",:checking_account_name=>"tcs")
  end

  it "should show login page with warning message when IBM Student3 try to access TCS course's discussion topics by changing whole URL" do
    discussion_corss_check(:account_name=> "ibm",:user_name=>"ibm.st1@arrivusystems.com",:discussion_topic_ids=>[tcs_course1_discussion_topic.id,
                            tcs_course2_discussion_topic.id,tcs_course2_discussion_topic.id],:access_type=> "change url",:checking_account_name=>"tcs")
  end

  #### TCS students viewing IBM course's discussion topics in ibm domain by changing whole url

  it "should show show login page with warning message when TCS Student1 try to access IBM course's discussion topics by changing whole URL" do
    discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.st1@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id,
                            ibm_course2_discussion_topic.id,ibm_course2_discussion_topic.id],:access_type=> "change url",:checking_account_name=>"ibm")
  end

  it "should show show login page with warning message when TCS Student2 try to access IBM course's discussion topics by changing whole URL" do
    discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.st1@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id,
                            ibm_course2_discussion_topic.id,ibm_course2_discussion_topic.id],:access_type=> "change url",:checking_account_name=>"ibm")
  end

  it "should show show login page with warning message when TCS Student3 try to access IBM course's discussion topics by changing whole URL" do
    discussion_corss_check(:account_name=> "tcs",:user_name=>"tcs.st1@arrivusystems.com",:discussion_topic_ids=>[ibm_course1_discussion_topic.id,
                            ibm_course2_discussion_topic.id,ibm_course2_discussion_topic.id],:access_type=> "change url",:checking_account_name=>"ibm")
  end


  #### Teacher as a student in same domain

    it "should show the Discussion topic when IBM teacher1 enrolled as a student in IBM course4 of IBM domain" do
      discussion_check_by_admin(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",:discussion_topic_ids=>[ibm_course4_discussion_topic.id],:user_role=>"student")

    end

    it "should show the Discussion topic when TCS teacher1 enrolled as a student in TCS course4 of TCS domain" do
      discussion_check_by_admin(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",:discussion_topic_ids=>[tcs_course4_discussion_topic.id],:user_role=>"student")

    end

  #### Teacher as a student in different domain

  it "should show the Discussion topic page without editing options when a teacher1 enrolled as a student in other courses of different domain" do
    discussion_check_by_admin(:account_name=>"ibm",:user_name=>"ibm.tr1@arrivusystems.com",
                              :discussion_topic_ids=>[tcs_course4_discussion_topic.id],:user_role=>"student")

  end

  it "should show the  Discussion topic page without editing options when a teacher1 enrolled as a student in other courses of different domain" do
    discussion_check_by_admin(:account_name=>"tcs",:user_name=>"tcs.tr1@arrivusystems.com",
                              :discussion_topic_ids=>[ibm_course4_discussion_topic.id],:user_role=>"student")

  end


end

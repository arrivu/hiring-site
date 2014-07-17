#require File.expand_path(File.dirname(__FILE__) + '/common_mt')
#require File.expand_path(File.dirname(__FILE__) + '/data_setup')
#
#describe "wikipages_Cross_Check_Creation" do
#
#  it_should_behave_like "in-process server selenium tests"
#
#  ##### Admin view their own wiki pages
#
#  def discussion_check_by_admin(params={})
#    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
#    fill_in_login_form(params[:user_name],"Admin123$")
#    wait_for_ajaximations
#    f('.user_name').text.should == params[:user_name]
#    params[:wiki_pages].each do |wiki_page_id|
#
#      wiki_page_details=Wiki.find(wiki_page).wiki_pages
#      course=Course.find()
#      #course=Course.find(discussion_topic_details.context_id)
#      #author_name=User.find(discussion_topic_details.user_id).name
#      driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course.id}/discussion_topics"
#      f("#section-tabs-header").text.should include_text  course.course_code
#      driver.find_element(:id,'new-discussion-btn').should be_displayed
#      f('.title').should include_text discussion_topic_details.title
#      driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course.id}/discussion_topics/#{discussion_topic_id}"
#      wait_for_ajaximations
#      f("#breadcrumbs").should include_text discussion_topic_details.title
#      ('#content').should_not include_text(discussion_topic_details.title)
#      f('.discussion-title').should include_text discussion_topic_details.title
#      f('.author').should include_text author_name
#      if params[:user_role]!="student"
#        f('.icon-edit').should be_displayed
#      end
#
#    end
#    expect_new_page_load { f('.logout > a').click }
#  end
#
#  it "should login as a IBM Admin and view all the Wiki pages in their own domain" do
#
#
#  end
#
#
#end
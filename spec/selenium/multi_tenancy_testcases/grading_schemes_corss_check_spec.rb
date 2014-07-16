require File.expand_path(File.dirname(__FILE__) + '/common_mt')
require File.expand_path(File.dirname(__FILE__) + '/data_setup')

describe "grading_schemes_Cross_Check_Creation" do

  it_should_behave_like "in-process server selenium tests"

  def view_grading_standard(params={})
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form(params[:user_name],"Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == params[:user_name]
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/accounts/#{params[:account_id]}/grading_standards"
    f("#section-tabs-header").text.should include_text params[:account_name]
    f("#content").text.should include_text "Grading Schemes"
    f("#grading_standard_#{params[:grading_standard_id]}").should be_displayed
    fj("a:contains(' Add Grading Scheme')").should be_displayed
    fj(".edit_grading_standard_link").should be_displayed
    fj(".delete_grading_standard_link").should be_displayed
    expect_new_page_load { f('.logout > a').click }
  end

  def grading_standards_corss_check(params={})
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form(params[:user_name],"Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == params[:user_name]
    params[:accounts].each do |account_name|
      account_id=Account.find_by_name(account_name).id
      if params[:access_type]=="change account id only"
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/accounts/#{account_id}/grading_standards"
        driver.find_element(:id,"unauthorized_holder").should be_displayed
        driver.find_element(:id,"unauthorized_message").should be_displayed
        f('.ui-state-error').should include_text("Unauthorized")
      end

      if params[:access_type]=="change url"
        driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
        driver.get "http://#{account_name}.lvh.me:#{$server_port}/accounts/#{account_id}/grading_standards"
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



  ##### Admin view their own grading standards

  it "should login as a IBM Admin and view their course's discussion topics" do
    view_grading_standard(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:account_id=>ibm_account.id,:grading_standard_id=>ibm_grade_book.id)
  end

  it "should login as a TCS Admin and view their course's discussion topics" do
    view_grading_standard(:account_name=>"tcs",:user_name=>"tcs@arrivusystems.com",:account_id=>tcs_account.id,:grading_standard_id=>tcs_grade_book.id)
  end

  it "should login as a BEACON Admin and view their course's discussion topics" do
    view_grading_standard(:account_name=>"beacon",:user_name=>"beacon@arrivusystems.com",:account_id=>beacon_account.id,:grading_standard_id=>beacon_grade_book.id)
  end

  it "should login as a CISCO Admin and view their course's discussion topics" do
    view_grading_standard(:account_name=>"cisco",:user_name=>"cisco@arrivusystems.com",:account_id=>cisco_account.id,:grading_standard_id=>cisco_grade_book.id)
  end

  it "should login as a INFOSYS Admin and view their course's discussion topics" do
    view_grading_standard(:account_name=>"infosys",:user_name=>"infosys@arrivusystems.com",:account_id=>infosys_account.id,:grading_standard_id=>infosys_grade_book.id)
  end

  ####  Admin users try to other courses grading book by only changing account id

  it "should show unauthorized message when IBM admin user trying to access other domains Grading Standards by changing account id only" do
    grading_standards_corss_check(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:accounts=>["tcs","cisco","infosys","beacon"],:access_type=>"change account id only")
  end

  it "should show unauthorized message when TCS admin user trying to access other domains Grading Standards by changing account id only" do
    grading_standards_corss_check(:account_name=>"tcs",:user_name=>"tcs@arrivusystems.com",:accounts=>["ibm","cisco","infosys","beacon"],:access_type=>"change account id only")
  end

  it "should show unauthorized message when CISCO admin user trying to access other domains Grading Standards by changing account id only" do
    grading_standards_corss_check(:account_name=>"cisco",:user_name=>"cisco@arrivusystems.com",:accounts=>["tcs","ibm","infosys","beacon"],:access_type=>"change account id only")
  end

  it "should show unauthorized message when INFOSYS admin user trying to access other domains Grading Standards by changing account id only" do
    grading_standards_corss_check(:account_name=>"infosys",:user_name=>"infosys@arrivusystems.com",:accounts=>["tcs","cisco","ibm","beacon"],:access_type=>"change account id only")
  end

  it "should show unauthorized message when BEACON admin user trying to access other domains Grading Standards by changing account id only" do
    grading_standards_corss_check(:account_name=>"beacon",:user_name=>"beacon@arrivusystems.com",:accounts=>["tcs","cisco","infosys","ibm"],:access_type=>"change account id only")
  end

  ####  Admin users try to other courses grading book bychanging whole url

  it "should show login page with warning message when IBM admin user trying to access other domains Grading Standards by changing whole url" do
    grading_standards_corss_check(:account_name=>"ibm",:user_name=>"ibm@arrivusystems.com",:accounts=>["tcs","cisco","infosys","beacon"],:access_type=>"change url")
  end

  it "should show login page with warning message when TCS admin user trying to access other domains Grading Standards by changing whole url" do
    grading_standards_corss_check(:account_name=>"tcs",:user_name=>"tcs@arrivusystems.com",:accounts=>["ibm","cisco","infosys","beacon"],:access_type=>"change url")
  end

  it "should show login page with warning message when CISCO admin user trying to access other domains Grading Standards by changing whole url" do
    grading_standards_corss_check(:account_name=>"cisco",:user_name=>"cisco@arrivusystems.com",:accounts=>["tcs","ibm","infosys","beacon"],:access_type=>"change url")
  end

  it "should show login page with warning message when INFOSYS admin user trying to access other domains Grading Standards by changing whole url" do
    grading_standards_corss_check(:account_name=>"infosys",:user_name=>"infosys@arrivusystems.com",:accounts=>["tcs","cisco","ibm","beacon"],:access_type=>"change url")
  end

  it "should show login page with warning message when BEACON admin user trying to access other domains Grading Standards by changing whole url" do
    grading_standards_corss_check(:account_name=>"beacon",:user_name=>"beacon@arrivusystems.com",:accounts=>["tcs","cisco","infosys","ibm"],:access_type=>"change url")
  end

end

require File.expand_path(File.dirname(__FILE__) + '/common_mt')
require File.expand_path(File.dirname(__FILE__) + '/data_setup')

describe "Acount creation and Admin user creation test" do

  it_should_behave_like "in-process server selenium tests"

  #add_mt_account("ibm")
  #ibm_sub_account1=add_sub_account_mt("ibm","ibm_sub_account1","ibm.s1@arrivusystems.com","Admin123$")
  #ibm_sub_account2=add_sub_account_mt("ibm","ibm_sub_account2","ibm.s2@arrivusystems.com","Admin123$")
  #
  #add_mt_account("tcs")
  #tcs_sub_account1=add_sub_account_mt("tcs","tcs_sub_account1","tcs.s1@arrivusystems.com","Admin123$")
  #tcs_sub_account2=add_sub_account_mt("tcs","tcs_sub_account2","tcs.s2@arrivusystems.com","Admin123$")
  #
  #add_mt_account("cisco")
  #cisco_sub_account1=add_sub_account_mt("cisco","cisco_sub_account1","cisco.s1@arrivusystems.com","Admin123$")
  #cisco_sub_account2=add_sub_account_mt("cisco","cisco_sub_account2","cisco.s2@arrivusystems.com","Admin123$")
  #
  #add_mt_account("beacon")
  #beacon_sub_account1=add_sub_account_mt("beacon","beacon_sub_account1","beacon.s1@arrivusystems.com","Admin123$")
  #beacon_sub_account2=add_sub_account_mt("beacon","beacon_sub_account2","beacon.s2@arrivusystems.com","Admin123$")
  #
  #add_mt_account("infosys")
  #infosys_sub_account1=add_sub_account_mt("infosys","infosys_sub_account1","infosys.s1@arrivusystems.com","Admin123$")
  #infosys_sub_account2=add_sub_account_mt("infosys","infosys_sub_account2","infosys.s2@arrivusystems.com","Admin123$")


  def sub_account_login(params={})

    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form(params[:user_name],params[:password])
    wait_for_ajaximations
    f('.user_name').text.should == params[:user_name]
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/accounts/#{params[:sub_account_id]}/settings"
    sleep 1
    f("#section-tabs-header").should include_text(params[:sub_account_name])
    fj('#tab-announcements-link:visible').should be_nil
    f('.faculty_journal:visible').should be_nil
    f('.terms:visible').should be_nil
    f('.admin_tools:visible').should be_nil
    expect_new_page_load { f('.logout > a').click }
  end

  def sub_account_login_cross_test(params={})
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form(params[:user_name],params[:password])
    assert_flash_error_message /Incorrect username/
  end

  before do
    @login_error_box_css = ".error_text:last"
  end

  it "should login as a admin user in ibm_sub_account1" do

    #driver.get "http://ibm.lvh.me:#{$server_port}"
    #fill_in_login_form("ibm.s1@arrivusystems.com","Admin123$")
    #f('.user_name').text.should == "ibm.s1@arrivusystems.com"
    #driver.get "http://ibm.lvh.me:#{$server_port}/accounts/#{ibm_sub_account1.id}/settings"
    #f("#section-tabs-header").should include_text("ibm_sub_account1")
    #fj('#tab-announcements-link:visible').should be_nil
    #f('.faculty_journal:visible').should be_nil
    #f('.terms:visible').should be_nil
    #f('.admin_tools:visible').should be_nil
    #expect_new_page_load { f('.logout > a').click }

    sub_account_login(:account_name=>"ibm",:sub_account_name=>"ibm_sub_account1",:sub_account_id=>ibm_sub_account1.id, :user_name=>"ibm.s1@arrivusystems.com", :password=>"Admin123$")

  end

  it "should login as a admin user in ibm_sub_account2" do
    sub_account_login(:account_name=>"ibm",:sub_account_name=>"ibm_sub_account2",:sub_account_id=>ibm_sub_account2.id, :user_name=>"ibm.s2@arrivusystems.com", :password=>"Admin123$")
  end

  it "should login as a admin user in tcs_sub_account1" do
    sub_account_login(:account_name=>"tcs",:sub_account_name=>"tcs_sub_account1",:sub_account_id=>tcs_sub_account1.id, :user_name=>"tcs.s1@arrivusystems.com", :password=>"Admin123$")
  end

  it "should login as a admin user in tcs_sub_account2" do
    sub_account_login(:account_name=>"tcs",:sub_account_name=>"tcs_sub_account2",:sub_account_id=>tcs_sub_account2.id, :user_name=>"tcs.s2@arrivusystems.com", :password=>"Admin123$")
  end
                                  nil
  it "should login as a admin user in cisco_sub_account1" do
    sub_account_login(:account_name=>"cisco",:sub_account_name=>"cisco_sub_account1",:sub_account_id=>cisco_sub_account1.id, :user_name=>"cisco.s1@arrivusystems.com", :password=>"Admin123$")
  end

  it "should login as a admin user in cisco_sub_account2" do
    sub_account_login(:account_name=>"cisco",:sub_account_name=>"cisco_sub_account2",:sub_account_id=>cisco_sub_account2.id, :user_name=>"cisco.s2@arrivusystems.com", :password=>"Admin123$")
  end

  it "should login as a admin user in beacon_sub_account1" do
    sub_account_login(:account_name=>"beacon",:sub_account_name=>"beacon_sub_account1",:sub_account_id=>beacon_sub_account1.id, :user_name=>"beacon.s1@arrivusystems.com", :password=>"Admin123$")
  end

  it "should login as a admin user in beacon_sub_account2" do
    sub_account_login(:account_name=>"beacon",:sub_account_name=>"beacon_sub_account2",:sub_account_id=>beacon_sub_account2.id, :user_name=>"beacon.s2@arrivusystems.com", :password=>"Admin123$")
  end

  it "should login as a admin user in infosys_sub_account1" do
    sub_account_login(:account_name=>"infosys",:sub_account_name=>"infosys_sub_account1",:sub_account_id=>infosys_sub_account1.id, :user_name=>"infosys.s1@arrivusystems.com", :password=>"Admin123$")
  end

  it "should login as a admin user in infosys_sub_account2" do
    sub_account_login(:account_name=>"infosys",:sub_account_name=>"infosys_sub_account2",:sub_account_id=>infosys_sub_account2.id, :user_name=>"infosys.s2@arrivusystems.com", :password=>"Admin123$")
  end

  it "should not login when other domain users login in IBM domain" do

    sub_account_login_cross_test(:account_name=>"ibm",:user_name=>"tcs.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"ibm",:user_name=>"tcs.s2@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"ibm",:user_name=>"infosys.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"ibm",:user_name=>"infosys.s2@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"ibm",:user_name=>"beacon.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"ibm",:user_name=>"beacon.s2@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"ibm",:user_name=>"cisco.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"ibm",:user_name=>"cisco.s2@arrivusystems.com",:password=>"Admin123$")

  end

  it "should not login when other domain users login in TCS domain" do

    sub_account_login_cross_test(:account_name=>"tcs",:user_name=>"ibm.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"tcs",:user_name=>"ibm.s2@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"tcs",:user_name=>"infosys.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"tcs",:user_name=>"infosys.s2@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"tcs",:user_name=>"beacon.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"tcs",:user_name=>"beacon.s2@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"tcs",:user_name=>"cisco.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"tcs",:user_name=>"cisco.s2@arrivusystems.com",:password=>"Admin123$")

  end

  it "should not login when other domain users login in CISCO domain" do

    sub_account_login_cross_test(:account_name=>"cisco",:user_name=>"ibm.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"cisco",:user_name=>"ibm.s2@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"cisco",:user_name=>"infosys.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"cisco",:user_name=>"infosys.s2@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"cisco",:user_name=>"beacon.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"cisco",:user_name=>"beacon.s2@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"cisco",:user_name=>"tcs.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"cisco",:user_name=>"tcs.s2@arrivusystems.com",:password=>"Admin123$")

  end

  it "should not login when other domain users login in INFOSYS domain" do

    sub_account_login_cross_test(:account_name=>"infosys",:user_name=>"ibm.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"infosys",:user_name=>"ibm.s2@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"infosys",:user_name=>"cisco.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"infosys",:user_name=>"cisco.s2@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"infosys",:user_name=>"beacon.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"infosys",:user_name=>"beacon.s2@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"infosys",:user_name=>"tcs.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"infosys",:user_name=>"tcs.s2@arrivusystems.com",:password=>"Admin123$")

  end

  it "should not login when other domain users login in BEACON domain" do

    sub_account_login_cross_test(:account_name=>"beacon",:user_name=>"ibm.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"beacon",:user_name=>"ibm.s2@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"beacon",:user_name=>"cisco.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"beacon",:user_name=>"cisco.s2@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"beacon",:user_name=>"infosys.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"beacon",:user_name=>"infosys.s2@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"beacon",:user_name=>"tcs.s1@arrivusystems.com",:password=>"Admin123$")
    sub_account_login_cross_test(:account_name=>"beacon",:user_name=>"tcs.s2@arrivusystems.com",:password=>"Admin123$")

  end

end
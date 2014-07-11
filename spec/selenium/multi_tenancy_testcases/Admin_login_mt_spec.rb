require File.expand_path(File.dirname(__FILE__) + '/common_mt')
require File.expand_path(File.dirname(__FILE__) + '/data_setup')

describe "Acount and Admin user creation test" do

  it_should_behave_like "in-process server selenium tests"
  #
  #ibm_account=add_mt_account("ibm")
  #add_mt_account_admin_users("ibm","ibm@arrivusystems.com","Admin123$")
  #
  #tcs_account=add_mt_account("tcs")
  #add_mt_account_admin_users("tcs","tcs@arrivusystems.com","Admin123$")
  #
  #cisco_account=add_mt_account("cisco")
  #add_mt_account_admin_users("cisco","cisco@arrivusystems.com","Admin123$")
  #
  #beacon_account=add_mt_account("beacon")
  #add_mt_account_admin_users("beacon","beacon@arrivusystems.com","Admin123$")
  #
  #infosys_account=add_mt_account("infosys")
  #add_mt_account_admin_users("infosys","infosys@arrivusystems.com","Admin123$")


  before do
    @login_error_box_css = ".error_text:last"
  end


  it "should create a admin user for ibm account and login with it" do
    driver.get "http://ibm.lvh.me:#{$server_port}"
    fill_in_login_form("ibm@arrivusystems.com","Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == "ibm@arrivusystems.com"
    driver.get "http://ibm.lvh.me:#{$server_port}/accounts/#{ibm_account.id}/settings"
    driver.find_element(:id, 'account_settings').should be_displayed
    f("#tab-sms-settings-link").should be_displayed
    expect_new_page_load { f('.logout > a').click }
  end

  it "should create a admin user for tcs account and login with it" do
    driver.get "http://tcs.lvh.me:#{$server_port}"
    fill_in_login_form("tcs@arrivusystems.com","Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == "tcs@arrivusystems.com"
    driver.get "http://tcs.lvh.me:#{$server_port}/accounts/#{tcs_account.id}/settings"
    driver.find_element(:id, 'account_settings').should be_displayed
    f("#tab-sms-settings-link").should be_displayed
    expect_new_page_load { f('.logout > a').click }
  end

  it "should create a admin user for cisco account and login with it" do
    driver.get "http://cisco.lvh.me:#{$server_port}"
    fill_in_login_form("cisco@arrivusystems.com","Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == "cisco@arrivusystems.com"
    driver.get "http://cisco.lvh.me:#{$server_port}/accounts/#{cisco_account.id}/settings"
    driver.find_element(:id, 'account_settings').should be_displayed
    f("#tab-sms-settings-link").should be_displayed
    expect_new_page_load { f('.logout > a').click }
  end

  it "should create a admin user for beacon account and login with it" do
    driver.get "http://beacon.lvh.me:#{$server_port}"
    fill_in_login_form("beacon@arrivusystems.com","Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == "beacon@arrivusystems.com"
    driver.get "http://beacon.lvh.me:#{$server_port}/accounts/#{beacon_account.id}/settings"
    driver.find_element(:id, 'account_settings').should be_displayed
    f("#tab-sms-settings-link").should be_displayed
    expect_new_page_load { f('.logout > a').click }
  end

  it "should create a admin user for infosys account and login with it" do
    driver.get "http://infosys.lvh.me:#{$server_port}"
    fill_in_login_form("infosys@arrivusystems.com","Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == "infosys@arrivusystems.com"
    driver.get "http://infosys.lvh.me:#{$server_port}/accounts/#{infosys_account.id}/settings"
    driver.find_element(:id, 'account_settings').should be_displayed
    f("#tab-sms-settings-link").should be_displayed
    expect_new_page_load { f('.logout > a').click }
  end

  it "should not login when other domain users login in IBM domain" do

    driver.get "http://ibm.lvh.me:#{$server_port}"
    fill_in_login_form("tcs@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://ibm.lvh.me:#{$server_port}"
    fill_in_login_form("infosys@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://ibm.lvh.me:#{$server_port}"
    fill_in_login_form("beacon@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://ibm.lvh.me:#{$server_port}"
    fill_in_login_form("cisco@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

  end

  it "should not login when other domain users login in TCS domain" do

    driver.get "http://tcs.lvh.me:#{$server_port}"
    fill_in_login_form("ibm@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://tcs.lvh.me:#{$server_port}"
    fill_in_login_form("beacon@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://tcs.lvh.me:#{$server_port}"
    fill_in_login_form("cisco@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://tcs.lvh.me:#{$server_port}"
    fill_in_login_form("infosys@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

  end

  it "should not login when other domain users login in CISCO domain" do

    driver.get "http://cisco.lvh.me:#{$server_port}"
    fill_in_login_form("ibm@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://cisco.lvh.me:#{$server_port}"
    fill_in_login_form("tcs@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://cisco.lvh.me:#{$server_port}"
    fill_in_login_form("infosys@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://cisco.lvh.me:#{$server_port}"
    fill_in_login_form("beacon@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

  end

  it "should not login when other domain users login in INFOSYS domain" do

    driver.get "http://infosys.lvh.me:#{$server_port}"
    fill_in_login_form("ibm@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://infosys.lvh.me:#{$server_port}"
    fill_in_login_form("tcs@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://infosys.lvh.me:#{$server_port}"
    fill_in_login_form("beacon@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://infosys.lvh.me:#{$server_port}"
    fill_in_login_form("cisco@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

  end

  it "should not login when other domain users login in BEACON domain" do

    driver.get "http://beacon.lvh.me:#{$server_port}"
    fill_in_login_form("ibm@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://beacon.lvh.me:#{$server_port}"
    fill_in_login_form("tcs@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://beacon.lvh.me:#{$server_port}"
    fill_in_login_form("cisco@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://beacon.lvh.me:#{$server_port}"
    fill_in_login_form("infosys@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

  end

end
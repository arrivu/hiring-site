require File.expand_path(File.dirname(__FILE__) + '/common_mt')
require File.expand_path(File.dirname(__FILE__) + '/data_setup')

describe "Site_Admin user creation test" do

  it_should_behave_like "in-process server selenium tests"

  def fill_sms_settings_form(sms_url,username, password,sender_name)
    url_element= f('#account_settings_Sublime_sms_url')
    url_element.send_keys(sms_url)
    username_element = f('#account_settings_Sublime_sms_user')
    username_element.send_keys(username)
    password_element = f('#account_settings_Sublime_sms_password')
    password_element.send_keys(password)
    sender_element=f('#account_settings_Sublime_sms_sender_name')
    sender_element.send_keys(sender_name)
    sender_element.submit
  end

  account=create_site_admin("Sublime","Sublime@arrivusystems.com","Admin123$")
  #ibm_account=add_mt_account("ibm")
  #tcs_account=add_mt_account("tcs")
  #cisco_account =add_mt_account("cisco")
  #beacon_account=add_mt_account("beacon")
  #infosys_account=add_mt_account("infosys")

  before do
    @login_error_box_css = ".error_text:last"
  end

  def site_admin_login(params={})
    driver.get "http://Sublime.lvh.me:#{$server_port}"
    fill_in_login_form("Sublime@arrivusystems.com","Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == "Sublime@arrivusystems.com"
    driver.get "http://Sublime.lvh.me:#{$server_port}/accounts/#{params[:account_id]}/settings"
    f("#section-tabs-header").text.should== params[:checking_account_name]
    fj("#account_name").should have_value(params[:checking_account_name])
    f("#tab-sms-settings-link").should be_displayed
    f("#tab-sms-settings-link").click
    fill_sms_settings_form(params[:sms_url],params[:sms_user_name],params[:sms_password],params[:sms_sender])
    refresh_page
    f("#tab-sms-settings-link").click
    sleep 1
    f('#account_settings_Sublime_sms_url').should have_value(params[:sms_url])
    f('#account_settings_Sublime_sms_user').should have_value(params[:sms_user_name])
    f('#account_settings_Sublime_sms_password').should have_value(params[:sms_password])
    f('#account_settings_Sublime_sms_sender_name').should have_value(params[:sms_sender])
    sleep 1
    expect_new_page_load { f('.logout > a').click }

  end


  it "should site administrator set the details for sms settings for IBM account" do
    site_admin_login(:checking_account_name=>"ibm",:account_id=>ibm_account.id,:sms_url=>"www.test.com",
                     :sms_user_name=>"test username",:sms_password=>"test password",:sms_sender=>"test sender")

  end

  it "should site administrator set the details for sms settings for TCS account" do
    site_admin_login(:checking_account_name=>"tcs",:account_id=>tcs_account.id,:sms_url=>"www.test.com",
                     :sms_user_name=>"test username",:sms_password=>"test password",:sms_sender=>"test sender")

  end

  it "should site administrator set the details for sms settings for TCS account" do
    site_admin_login(:checking_account_name=>"cisco",:account_id=>cisco_account.id,:sms_url=>"www.test.com",
                     :sms_user_name=>"test username",:sms_password=>"test password",:sms_sender=>"test sender")

  end

  it "should site administrator set the details for sms settings for TCS account" do
    site_admin_login(:checking_account_name=>"infosys",:account_id=>infosys_account.id,:sms_url=>"www.test.com",
                     :sms_user_name=>"test username",:sms_password=>"test password",:sms_sender=>"test sender")

  end

  it "should site administrator set the details for sms settings for TCS account" do
    site_admin_login(:checking_account_name=>"beacon",:account_id=>beacon_account.id,:sms_url=>"www.test.com",
                     :sms_user_name=>"test username",:sms_password=>"test password",:sms_sender=>"test sender")

  end


end
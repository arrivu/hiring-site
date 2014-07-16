require File.expand_path(File.dirname(__FILE__) + '/common_mt')
require File.expand_path(File.dirname(__FILE__) + '/data_setup')

describe "Site_Admin user creation and Login test" do

  it_should_behave_like "in-process server selenium tests"


  Sublime_account=create_site_admin("Sublime","Sublime@arrivusystems.com","Admin123$")

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

  #def site_admin_login(params={})
  #  account_names=[]
  #  account_ids=[]
  #  params[:accounts].each do |key,value|
  #   account_names << key
  #   account_ids << value
  #  end
  #  account_names.each do |account_name|
  #    account_ids.each do |account_id|
  #      checking_account_name=Account.find(account_id).name
  #      driver.get "http://#{account_name}.lvh.me:#{$server_port}"
  #      fill_in_login_form("Sublime@arrivusystems.com","Admin123$")
  #      sleep 1
  #      f('.user_name').text.should == "Sublime@arrivusystems.com"
  #      driver.get "http://#{account_name}.lvh.me:#{$server_port}/accounts/#{account_id}/settings"
  #      f("#section-tabs-header").text.should== checking_account_name
  #      f("#account_name").should have_value(checking_account_name)
  #      f("#tab-sms-settings-link").should be_displayed
  #      f("#tab-plugin-link").should be_displayed
  #      f("#tab-sms-settings-link").click
  #      sleep 1
  #      f("#tab-plugin-link").click
  #      sleep 1
  #      expect_new_page_load { f('.logout > a').click }
  #    end
  #  end
  #end
  #
  #it "should login in any account and can change the settings" do
  #  site_admin_login(:accounts=>{:Sublime=>Sublime_account.id,:ibm=>ibm_account.id,:tcs=>tcs_account.id,
  #                            :cisco=>cisco_account.id,:infosys=>infosys_account.id,:beacon=>beacon_account.id})
  #end


  ###
  # #working code
  #def login(account_name)
  #  driver.get "http://#{account_name}.lvh.me:#{$server_port}"
  #  fill_in_login_form("Sublime@arrivusystems.com","Admin123$")
  #  f('.user_name').text.should == "#{account_name}@arrivusystems.com"
  #end
  #def site_admin_login(params={})
  #  driver.get "http://#{params[:account]}.lvh.me:#{$server_port}/accounts/#{params[:checking_account_id]}/settings"
  #  f("#section-tabs-header").text.should== params[:checking_account_name]
  #  f("#account_name").should have_value(params[:checking_account_name])
  #  f("#tab-sms-settings-link").should be_displayed
  #  f("#tab-plugin-link").should be_displayed
  #  f("#tab-sms-settings-link").click
  #  sleep 1
  #  f("#tab-plugin-link").click
  #  sleep 1
  #
  #end
  #def logout
  #  expect_new_page_load { f('.logout > a').click }
  #end
  #
  #it "should login as a site administrator in Sublime" do
  #  login("Sublime")
  #  site_admin_login(:account=>"Sublime",:account_id=>Sublime_account.id,:checking_account_name=>"Sublime",:checking_account_id=>Sublime_account.id)
  #  site_admin_login(:account=>"Sublime",:account_id=>Sublime_account.id,:checking_account_name=>"ibm",:checking_account_id=>ibm_account.id)
  #  site_admin_login(:account=>"Sublime",:account_id=>Sublime_account.id,:checking_account_name=>"tcs",:checking_account_id=>tcs_account.id)
  #  site_admin_login(:account=>"Sublime",:account_id=>Sublime_account.id,:checking_account_name=>"beacon",:checking_account_id=>beacon_account.id)
  #  site_admin_login(:account=>"Sublime",:account_id=>Sublime_account.id,:checking_account_name=>"cisco",:checking_account_id=>cisco_account.id)
  #  site_admin_login(:account=>"Sublime",:account_id=>Sublime_account.id,:checking_account_name=>"infosys",:checking_account_id=>infosys_account.id)
  #  logout
  #
  #end

  ########

  def site_admin_login(params={})

    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form("Sublime@arrivusystems.com","Admin123$")
    wait_for_ajaximations
    #fj('.user_name').text.should == "Sublime@arrivusystems.com"
    f('.user_name').should include_text "Sublime@arrivusystems.com"
    params[:accounts].each do |account,account_id|
      checking_account_name=Account.find(account_id).name
      driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/accounts/#{account_id}/settings"
      f("#section-tabs-header").text.should== checking_account_name
      f("#account_name").should have_value(checking_account_name)
      fj("#tab-sms-settings-link").should be_displayed
      fj("#tab-plugin-link").should be_displayed
      f("#tab-sms-settings-link").click
      sleep 1
      f("#tab-plugin-link").click
      sleep 1
    end
    expect_new_page_load { f('.logout > a').click }
  end

  it "should login in Sublime account" do
    site_admin_login(:account_name=>"Sublime",:accounts=>{:Sublime=>Sublime_account.id,:ibm=>ibm_account.id,:tcs=>tcs_account.id,
                              :cisco=>cisco_account.id,:infosys=>infosys_account.id,:beacon=>beacon_account.id})
  end

  it "should login in IBM account" do
    site_admin_login(:account_name=>"ibm",:accounts=>{:Sublime=>Sublime_account.id,:ibm=>ibm_account.id,:tcs=>tcs_account.id,
                                                          :cisco=>cisco_account.id,:infosys=>infosys_account.id,:beacon=>beacon_account.id})
  end

  it "should login in TCS account" do
    site_admin_login(:account_name=>"tcs",:accounts=>{:Sublime=>Sublime_account.id,:ibm=>ibm_account.id,:tcs=>tcs_account.id,
                                                          :cisco=>cisco_account.id,:infosys=>infosys_account.id,:beacon=>beacon_account.id})
  end

  it "should login in BEACON account" do
    site_admin_login(:account_name=>"beacon",:accounts=>{:Sublime=>Sublime_account.id,:ibm=>ibm_account.id,:tcs=>tcs_account.id,
                                                          :cisco=>cisco_account.id,:infosys=>infosys_account.id,:beacon=>beacon_account.id})
  end

  it "should login in CISCO account" do
    site_admin_login(:account_name=>"cisco",:accounts=>{:Sublime=>Sublime_account.id,:ibm=>ibm_account.id,:tcs=>tcs_account.id,
                                                          :cisco=>cisco_account.id,:infosys=>infosys_account.id,:beacon=>beacon_account.id})
  end

  it "should login in INFOSYS account" do
    site_admin_login(:account_name=>"infosys",:accounts=>{:Sublime=>Sublime_account.id,:ibm=>ibm_account.id,:tcs=>tcs_account.id,
                                                          :cisco=>cisco_account.id,:infosys=>infosys_account.id,:beacon=>beacon_account.id})
  end


end
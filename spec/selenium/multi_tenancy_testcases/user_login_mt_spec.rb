require File.expand_path(File.dirname(__FILE__) + '/common_mt')
require File.expand_path(File.dirname(__FILE__) + '/data_setup')

describe "user creation and login test" do

  it_should_behave_like "in-process server selenium tests"
  #add_mt_account("ibm")
  #add_user("ibm","ibm.st1@arrivusystems.com","Admin123$")
  #add_user("ibm","ibm.st2@arrivusystems.com","Admin123$")
  #add_user("ibm","ibm.st3@arrivusystems.com","Admin123$")
  #add_user("ibm","ibm.st4@arrivusystems.com","Admin123$")
  #add_user("ibm","ibm.st5@arrivusystems.com","Admin123$")
  #
  #add_user("ibm","ibm.tr1@arrivusystems.com","Admin123$")
  #add_user("ibm","ibm.tr2@arrivusystems.com","Admin123$")
  #add_user("ibm","ibm.tr3@arrivusystems.com","Admin123$")
  #add_user("ibm","ibm.tr4@arrivusystems.com","Admin123$")
  #add_user("ibm","ibm.tr5@arrivusystems.com","Admin123$")
  #
  #add_mt_account("tcs")
  #add_user("tcs","tcs.st1@arrivusystems.com","Admin123$")
  #add_user("tcs","tcs.st2@arrivusystems.com","Admin123$")
  #add_user("tcs","tcs.st3@arrivusystems.com","Admin123$")
  #add_user("tcs","tcs.st4@arrivusystems.com","Admin123$")
  #add_user("tcs","tcs.st5@arrivusystems.com","Admin123$")
  #
  #add_user("tcs","tcs.tr1@arrivusystems.com","Admin123$")
  #add_user("tcs","tcs.tr2@arrivusystems.com","Admin123$")
  #add_user("tcs","tcs.tr3@arrivusystems.com","Admin123$")
  #add_user("tcs","tcs.tr4@arrivusystems.com","Admin123$")
  #add_user("tcs","tcs.tr5@arrivusystems.com","Admin123$")
  #
  #add_mt_account("cisco")
  #add_user("cisco","cisco.st1@arrivusystems.com","Admin123$")
  #add_user("cisco","cisco.st2@arrivusystems.com","Admin123$")
  #add_user("cisco","cisco.st3@arrivusystems.com","Admin123$")
  #add_user("cisco","cisco.st4@arrivusystems.com","Admin123$")
  #add_user("cisco","cisco.st5@arrivusystems.com","Admin123$")
  #
  #add_user("cisco","cisco.tr1@arrivusystems.com","Admin123$")
  #add_user("cisco","cisco.tr2@arrivusystems.com","Admin123$")
  #add_user("cisco","cisco.tr3@arrivusystems.com","Admin123$")
  #add_user("cisco","cisco.tr4@arrivusystems.com","Admin123$")
  #add_user("cisco","cisco.tr5@arrivusystems.com","Admin123$")
  #
  #add_mt_account("infosys")
  #add_user("infosys","infosys.st1@arrivusystems.com","Admin123$")
  #add_user("infosys","infosys.st2@arrivusystems.com","Admin123$")
  #add_user("infosys","infosys.st3@arrivusystems.com","Admin123$")
  #add_user("infosys","infosys.st4@arrivusystems.com","Admin123$")
  #add_user("infosys","infosys.st5@arrivusystems.com","Admin123$")
  #
  #add_user("infosys","infosys.tr1@arrivusystems.com","Admin123$")
  #add_user("infosys","infosys.tr2@arrivusystems.com","Admin123$")
  #add_user("infosys","infosys.tr3@arrivusystems.com","Admin123$")
  #add_user("infosys","infosys.tr4@arrivusystems.com","Admin123$")
  #add_user("infosys","infosys.tr5@arrivusystems.com","Admin123$")
  #
  #add_mt_account("beacon")
  #add_user("beacon","beacon.st1@arrivusystems.com","Admin123$")
  #add_user("beacon","beacon.st2@arrivusystems.com","Admin123$")
  #add_user("beacon","beacon.st3@arrivusystems.com","Admin123$")
  #add_user("beacon","beacon.st4@arrivusystems.com","Admin123$")
  #add_user("beacon","beacon.st5@arrivusystems.com","Admin123$")
  #
  #add_user("beacon","beacon.tr1@arrivusystems.com","Admin123$")
  #add_user("beacon","beacon.tr2@arrivusystems.com","Admin123$")
  #add_user("beacon","beacon.tr3@arrivusystems.com","Admin123$")
  #add_user("beacon","beacon.tr4@arrivusystems.com","Admin123$")
  #add_user("beacon","beacon.tr5@arrivusystems.com","Admin123$")

  before do
    @login_error_box_css = ".error_text:last"
  end

  it "should create user for ibm account and login with it" do

    driver.get "http://ibm.lvh.me:#{$server_port}"

    fill_in_login_form("ibm.st1@arrivusystems.com","Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == "ibm.st1@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("ibm.st2@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "ibm.st2@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("ibm.st3@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "ibm.st3@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("ibm.st4@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "ibm.st4@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("ibm.st5@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "ibm.st5@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("ibm.tr1@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "ibm.tr1@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("ibm.tr2@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "ibm.tr2@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("ibm.tr3@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "ibm.tr3@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("ibm.tr4@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "ibm.tr4@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("ibm.tr5@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "ibm.tr5@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


  end

  it "should create user for tcs account and login with it" do

    driver.get "http://tcs.lvh.me:#{$server_port}"

    fill_in_login_form("tcs.st1@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "tcs.st1@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("tcs.st2@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "tcs.st2@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("tcs.st3@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "tcs.st3@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("tcs.st4@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "tcs.st4@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("tcs.st5@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "tcs.st5@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("tcs.tr1@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "tcs.tr1@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("tcs.tr2@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "tcs.tr2@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("tcs.tr3@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "tcs.tr3@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("tcs.tr4@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "tcs.tr4@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("tcs.tr5@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "tcs.tr5@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


  end

  it "should create user for infosys account and login with it" do

    driver.get "http://infosys.lvh.me:#{$server_port}"

    fill_in_login_form("infosys.st1@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "infosys.st1@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("infosys.st2@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "infosys.st2@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("infosys.st3@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "infosys.st3@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("infosys.st4@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "infosys.st4@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("infosys.st5@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "infosys.st5@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("infosys.tr1@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "infosys.tr1@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("infosys.tr2@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "infosys.tr2@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("infosys.tr3@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "infosys.tr3@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("infosys.tr4@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "infosys.tr4@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("infosys.tr5@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "infosys.tr5@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }

  end

  it "should create user for cisco account and login with it" do

    driver.get "http://cisco.lvh.me:#{$server_port}"

    fill_in_login_form("cisco.st1@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "cisco.st1@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("cisco.st2@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "cisco.st2@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("cisco.st3@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "cisco.st3@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("cisco.st4@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "cisco.st4@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("cisco.st5@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "cisco.st5@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("cisco.tr1@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "cisco.tr1@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("cisco.tr2@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "cisco.tr2@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("cisco.tr3@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "cisco.tr3@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("cisco.tr4@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "cisco.tr4@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("cisco.tr5@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "cisco.tr5@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }

  end

  it "should create user for beacon account and login with it" do

    driver.get "http://beacon.lvh.me:#{$server_port}"

    fill_in_login_form("beacon.st1@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "beacon.st1@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("beacon.st2@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "beacon.st2@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("beacon.st3@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "beacon.st3@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("beacon.st4@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "beacon.st4@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("beacon.st5@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "beacon.st5@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("beacon.tr1@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "beacon.tr1@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("beacon.tr2@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "beacon.tr2@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("beacon.tr3@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "beacon.tr3@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("beacon.tr4@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "beacon.tr4@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }


    fill_in_login_form("beacon.tr5@arrivusystems.com","Admin123$")
    f('.user_name').text.should == "beacon.tr5@arrivusystems.com"
    expect_new_page_load { f('.logout > a').click }

  end

  it "should show invalid login when other users are login into IBM domain" do

    driver.get "http://ibm.lvh.me:#{$server_port}"
    fill_in_login_form("tcs.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/


    driver.get "http://ibm.lvh.me:#{$server_port}"
    fill_in_login_form("tcs.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://ibm.lvh.me:#{$server_port}"
    fill_in_login_form("beacon.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://ibm.lvh.me:#{$server_port}"
    fill_in_login_form("beacon.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://ibm.lvh.me:#{$server_port}"
    fill_in_login_form("infosys.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://ibm.lvh.me:#{$server_port}"
    fill_in_login_form("infosys.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://ibm.lvh.me:#{$server_port}"
    fill_in_login_form("cisco.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://ibm.lvh.me:#{$server_port}"
    fill_in_login_form("cisco.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

  end

  it "should show invalid login when other users are login into TCS domain" do

    driver.get "http://tcs.lvh.me:#{$server_port}"
    fill_in_login_form("ibm.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://tcs.lvh.me:#{$server_port}"
    fill_in_login_form("ibm.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://tcs.lvh.me:#{$server_port}"
    fill_in_login_form("beacon.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://tcs.lvh.me:#{$server_port}"
    fill_in_login_form("beacon.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://tcs.lvh.me:#{$server_port}"
    fill_in_login_form("infosys.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://tcs.lvh.me:#{$server_port}"
    fill_in_login_form("infosys.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://tcs.lvh.me:#{$server_port}"
    fill_in_login_form("cisco.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://tcs.lvh.me:#{$server_port}"
    fill_in_login_form("cisco.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/


  end


  it "should show invalid login when other users are login into CISCO domain" do

    driver.get "http://cisco.lvh.me:#{$server_port}"
    fill_in_login_form("ibm.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://cisco.lvh.me:#{$server_port}"
    fill_in_login_form("ibm.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://cisco.lvh.me:#{$server_port}"
    fill_in_login_form("beacon.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://cisco.lvh.me:#{$server_port}"
    fill_in_login_form("beacon.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://cisco.lvh.me:#{$server_port}"
    fill_in_login_form("infosys.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://cisco.lvh.me:#{$server_port}"
    fill_in_login_form("infosys.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://cisco.lvh.me:#{$server_port}"
    fill_in_login_form("tcs.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://cisco.lvh.me:#{$server_port}"
    fill_in_login_form("tcs.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/


  end

  it "should show invalid login when other users are login into INFOSYS domain" do

    driver.get "http://infosys.lvh.me:#{$server_port}"
    fill_in_login_form("ibm.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://infosys.lvh.me:#{$server_port}"
    fill_in_login_form("ibm.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://infosys.lvh.me:#{$server_port}"
    fill_in_login_form("beacon.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://infosys.lvh.me:#{$server_port}"
    fill_in_login_form("beacon.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://infosys.lvh.me:#{$server_port}"
    fill_in_login_form("cisco.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://infosys.lvh.me:#{$server_port}"
    fill_in_login_form("cisco.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://infosys.lvh.me:#{$server_port}"
    fill_in_login_form("tcs.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://infosys.lvh.me:#{$server_port}"
    fill_in_login_form("tcs.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/


  end


  it "should show invalid login when other users are login into BEACON domain" do

    driver.get "http://beacon.lvh.me:#{$server_port}"
    fill_in_login_form("ibm.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://beacon.lvh.me:#{$server_port}"
    fill_in_login_form("ibm.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://beacon.lvh.me:#{$server_port}"
    fill_in_login_form("infosys.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://beacon.lvh.me:#{$server_port}"
    fill_in_login_form("infosys.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://beacon.lvh.me:#{$server_port}"
    fill_in_login_form("cisco.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://beacon.lvh.me:#{$server_port}"
    fill_in_login_form("cisco.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://beacon.lvh.me:#{$server_port}"
    fill_in_login_form("tcs.st1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/

    driver.get "http://beacon.lvh.me:#{$server_port}"
    fill_in_login_form("tcs.tr1@arrivusystems.com","Admin123$")
    assert_flash_error_message /Incorrect username/


  end

end

require File.expand_path(File.dirname(__FILE__) + '/common_mt')
#require File.expand_path(File.dirname(__FILE__) + '/data_setup')

describe "student creation and login test" do

  it_should_behave_like "in-process server selenium tests"

  ibm_account=add_mt_account("ibm")
  tcs_account=add_mt_account("tcs")
  beacon_account=add_mt_account("beacon")
  cisco_account=add_mt_account("cisco")
  infosys_account=add_mt_account("infosys")

  ibm_course=course(:course_name=>"IBM course M1-Sample Course1", :account=>ibm_account, :active_course=>true)
  tcs_course=course(:course_name=>"TCS course M1-Sample Course1", :account=>tcs_account, :active_course=>true)
  beacon_course=course(:course_name=>"BEACON course M1-Sample Course1", :account=>beacon_account, :active_course=>true)
  cisco_course=course(:course_name=>"CISCO course M1-Sample Course1", :account=>cisco_account, :active_course=>true)
  infosys_course=course(:course_name=>"INFOSYS course M1-Sample Course1", :account=>infosys_account, :active_course=>true)

  ibm_user1=add_user("ibm","ibm.st1@arrivusystems.com","Admin123$")
  ibm_course.enroll_user(ibm_user1, 'StudentEnrollment', :enrollment_state => 'active')
  ibm_user2=add_user("ibm","ibm.st2@arrivusystems.com","Admin123$")
  ibm_course.enroll_user(ibm_user2, 'StudentEnrollment', :enrollment_state => 'active')

  tcs_user1=add_user("tcs","tcs.st1@arrivusystems.com","Admin123$")
  tcs_course.enroll_user(tcs_user1, 'StudentEnrollment', :enrollment_state => 'active')
  tcs_user2=add_user("tcs","tcs.st2@arrivusystems.com","Admin123$")
  tcs_course.enroll_user(tcs_user2, 'StudentEnrollment', :enrollment_state => 'active')

  cisco_user1=add_user("cisco","cisco.st1@arrivusystems.com","Admin123$")
  cisco_course.enroll_user(cisco_user1, 'StudentEnrollment', :enrollment_state => 'active')
  cisco_user2=add_user("cisco","cisco.st2@arrivusystems.com","Admin123$")
  cisco_course.enroll_user(cisco_user2, 'StudentEnrollment', :enrollment_state => 'active')

  infosys_user1=add_user("infosys","infosys.st1@arrivusystems.com","Admin123$")
  infosys_course.enroll_user(infosys_user1, 'StudentEnrollment', :enrollment_state => 'active')
  infosys_user2=add_user("infosys","infosys.st2@arrivusystems.com","Admin123$")
  infosys_course.enroll_user(infosys_user2, 'StudentEnrollment', :enrollment_state => 'active')

  beacon_user1=add_user("beacon","beacon.st1@arrivusystems.com","Admin123$")
  beacon_course.enroll_user(beacon_user1, 'StudentEnrollment', :enrollment_state => 'active')
  beacon_user2=add_user("beacon","beacon.st2@arrivusystems.com","Admin123$")
  beacon_course.enroll_user(beacon_user2, 'StudentEnrollment', :enrollment_state => 'active')

  def student_login(params={})

    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    params[:user_name].each do |user_name|
    fill_in_login_form(user_name,params[:password])
    wait_for_ajaximations
    f('.user_name').text.should == user_name
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{params[:course_id]}/users"
    driver.find_element(:name, 'search_term').send_keys(user_name)
    sleep 2
    f('.roster_user_name').should include_text(user_name)
    f('.collectionViewItems').should include_text("Student")
    sleep 2
    expect_new_page_load { f('.logout > a').click }
    end
  end

  def cross_check(params={})
    params[:user_name].each do |user_name|
      driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
      fill_in_login_form(user_name,params[:password])
      assert_flash_error_message /Incorrect username/
    end
  end

  it "should login as a student in IBM domain" do

    student_login(:account_name=>"ibm",:user_name=>['ibm.st1@arrivusystems.com','ibm.st2@arrivusystems.com'],
                  :password=>"Admin123$",:account_id=>ibm_account.id,:course_id=>ibm_course.id)

  end

  it "should login as a student in beacon domain" do

    student_login(:account_name=>"beacon",:user_name=>['beacon.st1@arrivusystems.com','beacon.st2@arrivusystems.com'],
                  :password=>"Admin123$",:account_id=>beacon_account.id,:course_id=>beacon_course.id)

  end

  it "should login as a student in tcs domain" do

    student_login(:account_name=>"tcs",:user_name=>['tcs.st1@arrivusystems.com','tcs.st2@arrivusystems.com'],
                  :password=>"Admin123$",:account_id=>tcs_account.id,:course_id=>tcs_course.id)

  end

  it "should login as a student in cisco domain" do

    student_login(:account_name=>"cisco",:user_name=>['cisco.st1@arrivusystems.com','cisco.st2@arrivusystems.com'],
                  :password=>"Admin123$",:account_id=>cisco_account.id,:course_id=>cisco_course.id)

  end

  it "should login as a student in infosys domain" do

    student_login(:account_name=>"infosys",:user_name=>['infosys.st1@arrivusystems.com','infosys.st2@arrivusystems.com'],
                  :password=>"Admin123$",:account_id=>infosys_account.id,:course_id=>infosys_course.id)

  end

  it "should show an error message when other domain users login in IBM account" do

    cross_check(:account_name=>"ibm",:password=>"Admin123$", :user_name=>['tcs.st1@arrivusystems.com',
                'infosys.st1@arrivusystems.com','cisco.st1@arrivusystems.com','beacon.st1@arrivusystems.com'])
  end

  it "should show an error message when other domain users login in TCS account" do

    cross_check(:account_name=>"tcs",:password=>"Admin123$", :user_name=>['ibm.st1@arrivusystems.com',
                                                                          'infosys.st1@arrivusystems.com','cisco.st1@arrivusystems.com','beacon.st1@arrivusystems.com'])
  end
  it "should show an error message when other domain users login in INFOSYS account" do

    cross_check(:account_name=>"infosys",:password=>"Admin123$", :user_name=>['tcs.st1@arrivusystems.com',
                                                                          'ibm.st1@arrivusystems.com','cisco.st1@arrivusystems.com','beacon.st1@arrivusystems.com'])
  end
  it "should show an error message when other domain users login in BEACON account" do

    cross_check(:account_name=>"beacon",:password=>"Admin123$", :user_name=>['tcs.st1@arrivusystems.com',
                                                                          'infosys.st1@arrivusystems.com','cisco.st1@arrivusystems.com','ibm.st1@arrivusystems.com'])
  end
  it "should show an error message when other domain users login in CISCO account" do

    cross_check(:account_name=>"cisco",:password=>"Admin123$", :user_name=>['tcs.st1@arrivusystems.com',
                                                                          'infosys.st1@arrivusystems.com','ibm.st1@arrivusystems.com','beacon.st1@arrivusystems.com'])
  end



end


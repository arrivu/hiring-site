require File.expand_path(File.dirname(__FILE__) + '/common_mt')
require File.expand_path(File.dirname(__FILE__) + '/data_setup')


describe "Files_Cross_Check" do

  it_should_behave_like "in-process server selenium tests"
  #### viewing account level files

  #def fixture_file_path(file)
  #  path = ActionController::TestCase.respond_to?(:fixture_path) ? ActionController::TestCase.send(:fixture_path) : nil
  #  return "#{path}#{file}"
  #end
  #
  #def fixture_file_upload(file, mimetype)
  #  ActionController::TestUploadedFile.new(fixture_file_path(file), mimetype)
  #end
  #fixture = fixture_file_upload('files/html-editing-test.html', 'text/html')
  #ibm_course1_file
  #tcs_course1_file


  def view_files(params={})
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}"
    fill_in_login_form(params[:user_name],"Admin123$")
    wait_for_ajaximations
    f('.user_name').text.should == params[:user_name]
    course=params[:course]
    course_name
    driver.get "http://#{params[:account_name]}.lvh.me:#{$server_port}/courses/#{course.id}/files##{course.name}"


  end

end
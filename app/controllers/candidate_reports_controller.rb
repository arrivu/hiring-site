require 'action_controller_test_process'

class CandidateReportsController < ApplicationController

  before_filter :require_context
  include Api::V1::Attachment

  def view_reports
    @candidate_detail = User.find_by_id(params[:candidate_id])
    @get_pseudonym = Pseudonym.find_by_user_id(params[:candidate_id])
    @quiz = Quizzes::Quiz.find(params[:quiz_id])
    @assignment = @quiz.assignment
    @submission = @quiz.quiz_submissions.find_by_user_id(params[:candidate_id], :order => 'created_at') rescue nil
    @quiz_stored = @quiz.stored_questions
    @image_proctoring = show_image
    @user_data = UserAcademic.find_all_by_user_id(params[:candidate_id])
    @user_experience = UserWorkExperience.find_all_by_user_id(params[:candidate_id])

  end

  def show_image
    @image_snap = []
    @image_snap_proctoring = []
    @image = Imageproctoring.find_all_by_user_id_and_quiz_id(params[:candidate_id],params[:quiz_id])
    @image.each do |image_shot|
      @time_elapsed = image_shot.time_elapsed
      @image_attach_id = image_shot.attachment_id
      @find_image = Attachment.find_by_id(@image_attach_id)
      #@image_proctor = request.protocol + request.host_with_port + "/images/thumbnails/" + @find_image.id.to_s + "/" + @find_image.uuid
      @image_proctor = file_download_url(@find_image, { :verifier => @find_image.uuid, :download => '1', :download_frd => '1' }) unless @find_image.nil?
      @image_snap <<  {:image_url => @image_proctor, :image_time => @time_elapsed}
    end
    @image_snap_proctoring << @image_snap
  end

  def generate_view
    @user_select_id = params[:student_ids]
    @check_pdf_options = {:allow_personal_detail => params[:data][:allow_personal_detail], :allow_academic_detail => params[:data][:allow_academic_detail],
                          :allow_employment_detail => params[:data][:allow_employment_detail], :allow_assessment_detail => params[:data][:allow_assessment_detail],
                          :allow_image_proctoring => params[:data][:allow_image_proctoring]}
    @users = []
    @users_full_array = []
    @user_select_id.each do |user_id|
      @candidate_detail = User.find_by_id(user_id)

      #@user_image_profile = Attachment.find_by_user_id_and_context_type_and_file_state(user_id,"User","available")
      @profile_pic = show_image_profile(user_id)
      @get_pseudonym = Pseudonym.find_by_user_id(user_id)
      @quiz = Quizzes::Quiz.find(params[:quiz_id])
      @assignment = @quiz.assignment
      @submission = @quiz.quiz_submissions.find_by_user_id(user_id, :order => 'created_at') rescue nil
      @quiz_stored = @quiz.stored_questions
      @image_proctoring = show_image_select_user(user_id)
      @user_data = UserAcademic.find_all_by_user_id(user_id)
      @user_experience = UserWorkExperience.find_all_by_user_id(user_id)
      @users_full_array = {:candidate_detail => @candidate_detail, :get_pseudonym => @get_pseudonym,:quiz => @quiz, :assignment => @assignment,
      :submission => @submission, :quiz_stored => @quiz_stored, :image_proctoring=> @image_proctoring, :user_data => @user_data,
      :user_experience => @user_experience, :profile_pic => @profile_pic}
      @users <<  @users_full_array
      end
    respond_to do |format|
      begin
          pdf_html = render_to_string(:template => "candidate_reports/generate_view.html.erb", :layout => "nil")
          logger.info("Success")
          pdf_file_name = "#{Time.now}_candidate_report.pdf"
          #pdf_file_name = "#{@user_select_id}_candidate_report.pdf"
          doc_pdf = WickedPdf.new.pdf_from_string(pdf_html)
          pdf_path = Rails.root.join('tmp', "#{pdf_file_name}")
          File.open(pdf_path, 'wb') do |file|
            file << doc_pdf
            report_attach(pdf_file_name,pdf_path)
          end
      rescue
          format.json {render :json => { :success => false }}
        end

      format.json { render :json => @users }
    end
    end
    #end


  def report_attach(pdf_file_name,pdf_path)
    filename = pdf_file_name
    filetype = 'application/pdf'
      @attachment = Attachment.new
      @attachment.uploaded_data = Rack::Test::UploadedFile.new(pdf_path.to_s, filetype, true)
      @attachment.display_name = filename
      @attachment.user = @current_user
      @attachment.context = @context
      @attachment.file_state = 'available'
      @attachment.save!
      @attachment
      @candidate_report = CandidateReport.new
      @candidate_report.quiz_id = @quiz.id
      @candidate_report.user_id = @current_user.id
      @candidate_report.attachment_id = @attachment.id
      @candidate_report.save!
      pdf_path.unlink
  end


  def generate_pdf_in_background
    send_later_enqueue_args(:generate_view, { :priority => Delayed::LOW_PRIORITY, :max_attempts => 1 })
  end

  def show_image_profile(user_id)
      @user_image_profile = Attachment.find_by_user_id_and_context_type_and_file_state(user_id,"User","available")
      @profile_pic = File.dirname(@user_image_profile.full_filename) + "/" + @user_image_profile.filename unless @user_image_profile.nil?
  end

  def show_image_select_user(user_id)
    @image_snap = []
    @image_snap_proctoring = []
    @image = Imageproctoring.find_all_by_user_id_and_quiz_id(user_id,params[:quiz_id])
    @image.each do |image_shot|
      @time_elapsed = image_shot.time_elapsed
      @image_attach_id = image_shot.attachment_id
      @find_image = Attachment.find_by_id(@image_attach_id)
      @image_proctor = File.dirname(@find_image.full_filename) + "/" + @find_image.filename unless @find_image.nil?
      @image_snap <<  {:image_url => @image_proctor, :image_time => @time_elapsed}
    end
    @image_snap_proctoring << @image_snap
  end

end


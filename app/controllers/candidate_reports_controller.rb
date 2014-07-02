class CandidateReportsController < ApplicationController

  before_filter :require_context

  def view_reports()

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
    params[:data]
  end
end



class CandidateReportsController < ApplicationController

  before_filter :require_context

  def view_reports()

    @candidate_detail = User.find_by_id(params[:candidate_id])
    @get_pseudonym = Pseudonym.find_by_user_id(params[:candidate_id])
    @quiz = Quizzes::Quiz.find(params[:quiz_id])
    @assignment = @quiz.assignment
    @submission = @quiz.quiz_submissions.find_by_user_id(params[:candidate_id], :order => 'created_at') rescue nil
    @quiz_stored = @quiz.stored_questions
    @image_proctoring_find = show_image
    @user_data = UserAcademic.find_all_by_user_id(params[:candidate_id])
    @user_experience = UserWorkExperience.find_all_by_user_id(params[:candidate_id])

  end

  def show_image
    @image_snap = []
    @image= Imageproctoring.find_all_by_user_id_and_quiz_id(params[:candidate_id],params[:quiz_id])
    #@image.each do |image_shot|
    #  @image_proctor = image_shot.imageData
    #  @image_snap << @image_proctor
    #end

  end

end

class CandidateReportsController < ApplicationController

  before_filter :require_context

  def view_reports()

    @candidate_detail = User.find_by_id(params[:candidate_id])
    @get_pseudonym = Pseudonym.find_by_user_id(params[:candidate_id])
    @quiz = Quizzes::Quiz.find(params[:quiz_id])
    @assignment = @quiz.assignment
    @submission = @quiz.quiz_submissions.find_by_user_id(params[:candidate_id], :order => 'created_at') rescue nil
    @quiz_stored = @quiz.stored_questions
    @user_data = UserAcademic.find_all_by_user_id(params[:candidate_id])
    @user_experience = UserWorkExperience.find_all_by_user_id(params[:candidate_id])
  end

end

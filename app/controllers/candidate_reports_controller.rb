class CandidateReportsController < ApplicationController

  def view_reports()

    @candidate_detail = User.find_by_id(params[:candidate_id])
    @quiz = Quizzes::Quiz.find(params[:quiz_id])
    @assignment = @quiz.assignment
    @submission = @quiz.quiz_submissions.find_by_user_id(params[:candidate_id], :order => 'created_at') rescue nil

  end

end

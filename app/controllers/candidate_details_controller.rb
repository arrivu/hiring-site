class CandidateDetailsController < ApplicationController
  before_filter :require_user
  before_filter :require_context, :only => [:enable_candidate]
  def enable_candidate
    @candidate_detail = @context.candidate_detail
    if @candidate_detail
      @candidate_detail= CandidateDetail.find_by_course_id(params[:course_id])
      update
    else
      @candidate_detail = @context.create_candidate_detail(params[:candidate_detail])
    end
    if @candidate_detail.save!
      flash[:success] = "Application Submitted Succesfully"
      redirect_to course_settings_url(@context)
    else
      flash[:error] = "Mandatory Fields should not be empty"
    end
  end

  def update
    @candidate_detail = CandidateDetail.find_by_course_id(params[:course_id])
    if @candidate_detail.update_attributes(params[:candidate_detail])
      flash[:success] ="Successfully Updated Settings."
    end

  end
end

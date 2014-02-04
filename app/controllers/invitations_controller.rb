class InvitationsController < ApplicationController

  before_filter :require_user
  before_filter :require_context

  def index

  end

  def get_candidates
    if authorized_action(@context, @current_user, :read_roster)
      log_asset_access("roster:#{@context.asset_string}", "roster", "other")
      @students = @context.participating_students.order_by_sortable_name
      respond_to do |format|
        format.json { render :json => @students}
      end

    end
  end

  def create
    if authorized_action(@context, @current_user, :read_roster)

    end
  end
end

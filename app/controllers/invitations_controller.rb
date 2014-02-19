class InvitationsController < ApplicationController

  before_filter :require_user
  before_filter :require_context

  def index
    return unless authorized_action(@domain_root_account, @current_user, [:create_courses, :manage_courses])
    js_env(:COURSE_ID => @context.id)
    js_env(:QUIZZ_ID => params[:quiz_id].to_i)
    sections = @context.course_sections.active.select([:id, :name])
    js_env(:COURSE_SECTION_LIST => sections.map { |s| { :id => s.id.to_s, :name => s.name } })
  end

  def get_candidates
    get_context
    if authorized_action(@context, @current_user, :read_roster)
      #backcompat limit param
      params[:per_page] ||= params.delete(:limit)

      search_params = params.slice(:search_term, :enrollment_role, :enrollment_type)
      search_term = search_params[:search_term].presence

      if search_term
        users = UserSearch.for_user_in_context(search_term, @context, @current_user, session, search_params)
      else
        users = UserSearch.scope_for(@context, @current_user, search_params)
      end
      @quiz = Quiz.find(params[:id])
      students = @context.participating_students.order_by_sortable_name
      students = Api.paginate(students, self, api_v1_course_invitations_url(@context,@quiz))

      render :json => students.map { |u|
        user_json(u, @current_user, session, [], @context)
      }
    end
  end

  def create
    if authorized_action(@context, @current_user, :read_roster)
      respond_to do |format|
        format.json  { render :json }
      end
    end
  end

  def accept_code
    @show_left_side = false
    clear_crumbs
    js_env(:COURSE_ID => @context.id)
    js_env(:QUIZZ_ID => params[:quiz_id].to_i)
  end

  def optional_register
    @show_left_side = false
    clear_crumbs
    js_env(:COURSE_ID => @context.id)
    js_env(:QUIZZ_ID => params[:quiz_id].to_i)
  end

end

class InvitationsController < ApplicationController

  before_filter :require_user
  before_filter :require_context
  skip_before_filter :require_context, :only => [:accept_code, :optional_register, :new]
  skip_before_filter :require_user, :only => [:accept_code, :optional_register, :new]

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

      search_params = params.slice(:search_term, :course_section_id, :enrollment_type)
      search_term = search_params[:search_term].presence
      @quiz = Quiz.find(params[:id])
      if search_term
        students = UserSearch.for_user_in_context(search_term, @context, @current_user, session, search_params)
      elsif params[:course_section_id]
        students = CourseSection.find(params[:course_section_id]).students.active
      else
        students = @context.participating_students.order_by_sortable_name
      end
      students = Api.paginate(students, self, api_v1_course_invitations_url(@context,@quiz))

      render :json => students.map { |u|
        user_json(u, @current_user, session, [], @context)
      }
    end
  end

  def create
    if authorized_action(@context, @current_user, :read_roster)
      @quiz = Quiz.find(params[:quiz_id])
      params[:login_ids].each do |login_id|
        candidate_pseudonym = Pseudonym.find_by_unique_id(login_id)
        @invitation = Invitation.find_by_quiz_id_and_pseudonym_id_and_workflow_status(@quiz.id,candidate_pseudonym.id,'active')
        unless @invitation
          @invitation = Invitation.find_or_create_by_quiz_id_and_pseudonym_id(@quiz.id,candidate_pseudonym.id,workflow_status: 'active')
          send_invitation_email(@invitation,candidate_pseudonym,candidate_pseudonym.user,@quiz)
        end
      end
      respond_to do |format|
        format.json  { render :json => @invitation }
      end
    end
  end

  def new
    @show_left_side = false
    @headers == false
    clear_crumbs
    @registerform = Candidate.new(params[:candidate_detail])
    #unless @check_enable = CandidateDetail.find_by_course_id(@context.id)
    #  @check_enable = CandidateDetail.new
    #else
    #  @check_enable = CandidateDetail.find_by_course_id(@context.id)
    #end
  end

  def accept_code
    @show_left_side = false
    @headers == false
    clear_crumbs
  end

  def optional_register
    @show_left_side = false
    @headers == false
    clear_crumbs

    @registerform = Candidate.new(params[:candidate_detail])

    if @registerform.save
      flash[:success] = "Application Submitted Succesfully"
      redirect_to root_url
    else
      flash[:error] = "Mandatory Fields should not be empty"
    end
  end

  def send_invitation_email(invitation,pseudonym,user,quiz)
    domains = HostUrl.context_hosts(@domain_root_account)
    @domain_url =  "#{HostUrl.protocol}://#{domains.first}/accept/"
      m = Message.new
      m.to = pseudonym.unique_id
      m.subject = "Assessment Invitation"
      m.html_body = "You have been invited by #{@current_user.name} to take the assessment #{quiz.title}"
      m.body = @domain_url+"#{invitation.access_code}"
      Mailer.send_later(:deliver_invitation_email,m,user)

  end

end

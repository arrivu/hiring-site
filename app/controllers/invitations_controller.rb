class InvitationsController < ApplicationController

  before_filter :require_user ,:except => [:accept_code, :optional_register, :new, :fill_registration_form]
  before_filter :require_context,:except => [:accept_code, :optional_register, :new, :fill_registration_form]

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
        create_access_code
        @invitation = Invitation.find_by_quiz_id_and_pseudonym_id_and_workflow_status(@quiz.id,candidate_pseudonym.id,'active')
        unless @invitation
          @invitation = Invitation.find_or_create_by_quiz_id_and_pseudonym_id(@quiz.id,candidate_pseudonym.id,workflow_status: 'active')
          send_invitation_email(@context,candidate_pseudonym,candidate_pseudonym.user,@quiz)
        end
      end
      respond_to do |format|
        format.json  { render :json => @invitation }
      end
    end
  end

  def create_access_code
    unique_code = @context.course_unique_code_association
    unless unique_code
      course_unique_code_association = @context.create_course_unique_code_association
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

  def fill_registration_form
    @show_left_side = false
    @headers == false
    if params[:invitation ][:access_code].present?   and   params[:invitation][:unique_id].present?
      unique_code_association = CourseUniqueCodeAssociation.find_by_unique_access_code(params[:invitation][:access_code])
      @context = unique_code_association.course
      @pseudonym = Pseudonym.custom_find_by_unique_id(params[:invitation][:unique_id])
      unless @pseudonym
        password=(0...10).map{ ('a'..'z').to_a[rand(26)] }.join
        @user = User.create!(:name => params[:invitation][:unique_id])
        @user.workflow_state = 'registered'
        @user_pseudonym = @user.pseudonyms.create!(:unique_id => params[:invitation][:unique_id],
                                              :account => @domain_root_account)
        @user.communication_channels.create!(:path => params[:invitation][:unique_id]) { |cc| cc.workflow_state = 'active' }
        @user.save!
        @user_pseudonym.save!
        @enrollment = @context.enroll_student(@user, :self_enrolled => true)
        @enrollment.workflow_state = 'active'
        @enrollment.save!
        end
   end
  end

  def optional_register
    @show_left_side = false
    @headers == false
    clear_crumbs
    if params[:link_degrees] && params[:link_disciplines] && params[:link_colleges] && params[:link_year_of_completions] && params[:link_percentages]
      links = params[:link_degrees].zip(params[:link_disciplines],params[:link_colleges],params[:link_year_of_completions],params[:link_percentages]).
          reject { |degrees, disciplines, colleges, year_of_completions, percentages| degrees.blank? && disciplines.blank? && colleges.blank? && year_of_completions.blank? && percentages.blank?}.
          map { |degrees, disciplines, colleges, year_of_completions, percentages|
        @user_academic = UserAcademic.new(:degree => degrees, :discipline => disciplines, :college => colleges, :year_of_completion => year_of_completions, :percentage => percentages)
        @user_academic.save
      }

    end

    if params[:link_organizations] && params[:link_from_dates] && params[:link_end_dates] && params[:link_designations] && params[:link_permanents] && params[:link_reason_for_leaving]
      links = params[:link_organizations].zip(params[:link_from_dates],params[:link_end_dates],params[:link_designations],params[:link_permanents],params[:link_reason_for_leaving]).
          reject { |organizations, from_dates, end_dates, designations, permanents, reason_for_leaving| organizations.blank? && from_dates.blank? && end_dates.blank? && designations.blank? && end_dates.blank? && permanents.blank? && reason_for_leaving.blank?}.
          map { |organizations, from_dates, end_dates, designations, permanents, reason_for_leaving|
        @user_work_experience = UserWorkExperience.new(:organization => organizations, :from_date => from_dates, :end_date => end_dates, :designation => designations, :permanent => permanents, :reason_for_leaving => reason_for_leaving)
        @user_work_experience.save
      }

    end

    if params[:link_degrees] && params[:link_disciplines] && params[:link_colleges] && params[:link_year_of_completions] && params[:link_percentages]
      links = params[:link_degrees].zip(params[:link_disciplines],params[:link_colleges],params[:link_year_of_completions],params[:link_percentages]).
          reject { |degrees, disciplines, colleges, year_of_completions, percentages| degrees.blank? && disciplines.blank? && colleges.blank? && year_of_completions.blank? && percentages.blank?}.
          map { |degrees, disciplines, colleges, year_of_completions, percentages|
        @user_academic = UserAcademic.new(:degree => degrees, :discipline => disciplines, :college => colleges, :year_of_completion => year_of_completions, :percentage => percentages)
        @user_academic.save
      }

    end

    @registerform = Candidate.new(params[:candidate_detail])

    if @registerform.save
      flash[:success] = "Application Submitted Succesfully"
      redirect_to courses_path
    else
      flash[:error] = "Mandatory Fields should not be empty"
    end
  end

  def send_invitation_email(context,pseudonym,user,quiz)
    domains = HostUrl.context_hosts(@domain_root_account)
    @domain_url =  "#{HostUrl.protocol}://#{domains.first}/accept/"
    m = Message.new
    m.to = pseudonym.unique_id
    m.subject = "Assessment Invitation"
    m.html_body = "You have been invited by #{@current_user.name} to take the assessment #{quiz.title}"
    m.body = @domain_url+"#{context.course_unique_code_association.unique_access_code}"
    Mailer.send_later(:deliver_invitation_email,m,user)

    end
end

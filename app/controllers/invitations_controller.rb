class InvitationsController < ApplicationController

  before_filter :require_user ,:except => [:accept_code, :new, :fill_registration_form]
  before_filter :require_context ,:except => [:accept_code, :new, :optional_register, :fill_registration_form]
  def index
    return unless authorized_action(@context, @current_user, [:create_courses, :manage_courses, :read])
    js_env(:COURSE_ID => @context.id)
    js_env(:QUIZZ_ID => params[:quiz_id].to_i)
    sections = @context.course_sections.active.select([:id, :name])
    js_env(:COURSE_SECTION_LIST => sections.map { |s| { :id => s.id.to_s, :name => s.name } })
  end

  def get_candidates
    @students = []
     if authorized_action(@context, @current_user, :read)
      #backcompat limit param
      params[:per_page] ||= params.delete(:limit)
      search_params = params.slice(:search_term, :course_section_id, :enrollment_type)
      search_term = search_params[:search_term].presence
      @quiz = Quizzes::Quiz.find(params[:id])
      if search_term
        #students = UserSearch.for_user_in_context(search_term, @context, @current_user, session, search_params)
        users = UserSearch.for_user_in_context(search_term, @context, @current_user, session, search_params)
      elsif params[:course_section_id]
        #students = CourseSection.find(params[:course_section_id]).students.active
        users = CourseSection.find(params[:course_section_id]).students.active
      else
        #students = @context.participating_students.order_by_sortable_name
        users = @context.participating_students.order_by_sortable_name
      end

      users.each do |user|
        @invitation_check = Invitation.find_by_pseudonym_id_and_quiz_id_and_workflow_status(user.id,@quiz.id,'active')
        if @invitation_check
          @email_send = true
        else
          @email_send = false
        end
        params[:send] = @email_send

        @invitation_send_json = api_json(user, session, API_USER_JSON_OPTS).tap do |json|
          json[:id] = user.id
          json[:name] = user.name
          json[:login_id] = user.pseudonym.unique_id
          json[:email_send] = params[:send]
        end
        @students << @invitation_send_json
      end
      @students = Api.paginate(@students, self, api_v1_course_invitations_url(@context,@quiz))
      respond_to do |format|
        format.json  { render :json => @students }
      end
      #render :json => students.map { |u|
      #  user_json(u, @current_user, session, [], @context)
      #}
    end
  end

  def create
    if authorized_action(@context, @current_user, :read_roster)
      @quiz = Quizzes::Quiz.find(params[:quiz_id])
      params[:login_ids].each do |login_id|
        candidate_pseudonym = Pseudonym.find_by_unique_id(login_id)
        @section = @context.course_sections.find(params[:course_section_id])
        get_unique_access_code(@context,@section,@quiz.id)
        @invitation = Invitation.find_by_quiz_id_and_pseudonym_id_and_workflow_status(@quiz.id,candidate_pseudonym.id,'active')
        unless @invitation
          @invitation = Invitation.find_or_create_by_quiz_id_and_pseudonym_id(@quiz.id,candidate_pseudonym.id,workflow_status: 'active')

        end
        send_invitation_email(@context,candidate_pseudonym,candidate_pseudonym.user,@quiz)
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
    @registerform = User.new(params[:candidate_detail])

  end

  def accept_code
    @show_left_side = false
    @headers = false
    clear_crumbs
  end

  def fill_registration_form
    @show_left_side = false
    @headers = false
    reset_session
    if params[:invitation ][:access_code].present?   and   params[:invitation][:unique_id].present?
      unique_code_association = CourseUniqueCodeAssociation.find_by_unique_access_code(params[:invitation][:access_code])
      unless unique_code_association.nil?
        @course_section = unique_code_association.course_section
        @course = unique_code_association.course(@course_section)
        @pseudonym = Pseudonym.custom_find_by_unique_id(params[:invitation][:unique_id])
        if @pseudonym
          @pseudonym_session = @domain_root_account.pseudonym_sessions.new(@pseudonym.user)
          @pseudonym_session = @domain_root_account.pseudonym_sessions.create!(@pseudonym, false)
          @current_pseudonym = @pseudonym
          @user = @pseudonym.user
        else
          password=(0...10).map{ ('a'..'z').to_a[rand(26)] }.join
          @user = User.create!(:name => params[:invitation][:unique_id])
          @user.workflow_state = 'registered'
          @user_pseudonym = @user.pseudonyms.create!(:unique_id => params[:invitation][:unique_id],
                                                     :account => @domain_root_account)
          @user.communication_channels.create!(:path => params[:invitation][:unique_id]) { |cc| cc.workflow_state = 'active' }
          @user.save!
          @user_pseudonym.save!
          @enrollment = @course.enroll_user(@user, type='StudentEnrollment',:enrollment_state => 'active',:section => @course_section)
          @enrollment.save!
        end
        @context = @current_user
        @get_pseudonym = Pseudonym.custom_find_by_unique_id(params[:invitation][:unique_id])
        @candidate_detail= @get_pseudonym.user
        @user ||= @current_user
        @user_data = UserAcademic.find_all_by_user_id(@candidate_detail.id)
        @user_experience = UserWorkExperience.find_all_by_user_id(@candidate_detail.id)
        @candidate_filter = CandidateDetail.find_by_course_id(@course.id)
        @bio = UserProfile.find_by_user_id(@candidate_detail.id)
        if @bio != nil
          @bio_text = @bio.bio
        end
        @candidate_email = params[:invitation][:unique_id]
        if @candidate_filter == nil
          redirect_to course_quizzes_path(@course)
        end
      else
        flash[:error] = "Invalid Access Code "
        redirect_to :back
      end

    end

  end

  def optional_register
    @show_left_side = false
    @headers = false
    clear_crumbs
    @user ||= @current_user
    @context = @user.profile if @user == @current_user
    #
    @user_data = profile_data(
        @user.profile,
        @current_user,
        session,
        ['links', 'user_services']
    )

    if UserProfile.find_by_user_id(@user.id) != nil
      @bio_update = UserProfile.find_by_user_id(@user.id)
      @bio_update.update_attributes(:bio => params[:bio])
    else
      @bio_update = UserProfile.new(:bio => params[:bio])
      @bio_update.user_id = @user.id
      @bio_update.save!
    end

    if params[:link_degrees] && params[:link_disciplines] && params[:link_colleges] && params[:link_year_of_completions] && params[:link_percentages] && params[:link_ids]
      user_academic_ids = @current_user.user_academic_ids
      if user_academic_ids
        link_ids = []
        params[:link_ids].map do |link_id|
          link_ids << link_id.to_i
        end
        comapre_and_delete(user_academic_ids,link_ids,UserAcademic)
      end
      links = params[:link_degrees].zip(params[:link_disciplines],params[:link_colleges],params[:link_year_of_completions],params[:link_percentages],params[:link_ids]).
          reject { |degrees, disciplines, colleges, year_of_completions, percentages,ids| degrees.blank? && disciplines.blank? && colleges.blank? && year_of_completions.blank? && percentages.blank? && ids.blank?}.
          map { |degrees, disciplines, colleges, year_of_completions, percentages, id|
        if id
          @user_academic = UserAcademic.find(id)
          @user_academic.update_attributes(:degree => degrees, :discipline => disciplines, :college => colleges, :year_of_completion => year_of_completions, :percentage => percentages, :user_id => @current_pseudonym[:user_id])
        else
          @user_academic = UserAcademic.new(:degree => degrees, :discipline => disciplines, :college => colleges, :year_of_completion => year_of_completions, :percentage => percentages, :user_id => @current_pseudonym[:user_id])
          @user_academic.save!
        end

      }
    elsif params[:link_degrees] && params[:link_disciplines] && params[:link_colleges] && params[:link_year_of_completions] && params[:link_percentages]
      links = params[:link_degrees].zip(params[:link_disciplines],params[:link_colleges],params[:link_year_of_completions],params[:link_percentages]).
          reject { |degrees, disciplines, colleges, year_of_completions, percentages,ids| degrees.blank? && disciplines.blank? && colleges.blank? && year_of_completions.blank? && percentages.blank? }.
          map { |degrees, disciplines, colleges, year_of_completions, percentages|
        @user_academic = UserAcademic.new(:degree => degrees, :discipline => disciplines, :college => colleges, :year_of_completion => year_of_completions, :percentage => percentages, :user_id => @current_pseudonym[:user_id])
        @user_academic.save!
      }

    end

    if params[:link_organizations] && params[:link_from_dates] && params[:link_end_dates] && params[:link_designations] && params[:link_permanents] && params[:link_reason_for_leaving] && params[:link_experience_ids]
      user_experience_ids = @current_user.user_work_experience_ids
      if user_experience_ids
        link_experience_ids = []
        params[:link_experience_ids].map do |link_experience_id|
          link_experience_ids << link_experience_id.to_i
        end
        comapre_and_delete(user_experience_ids,link_experience_ids,UserWorkExperience)
      end
      links = params[:link_organizations].zip(params[:link_from_dates],params[:link_end_dates],params[:link_designations],params[:link_permanents],params[:link_reason_for_leaving],params[:link_experience_ids]).
          reject { |organizations, from_dates, end_dates, designations, permanents, reason_for_leaving,experience_ids| organizations.blank? && from_dates.blank? && end_dates.blank? && designations.blank? && end_dates.blank? && permanents.blank? && reason_for_leaving.blank? && experience_ids.blank?}.
          map { |organizations, from_dates, end_dates, designations, permanents, reason_for_leaving, experience_ids|
        if experience_ids
          @user_work_experience = UserWorkExperience.find(experience_ids)
          @user_work_experience.update_attributes(:organization => organizations, :from_date => from_dates, :end_date => end_dates, :designation => designations, :permanent => permanents, :reason_for_leaving => reason_for_leaving, :user_id => @current_pseudonym[:user_id])
        else
          @user_work_experience = UserWorkExperience.new(:organization => organizations, :from_date => from_dates, :end_date => end_dates, :designation => designations, :permanent => permanents, :reason_for_leaving => reason_for_leaving, :user_id => @current_pseudonym[:user_id])
          @user_work_experience.save
        end

      }
    elsif params[:link_organizations] && params[:link_from_dates] && params[:link_end_dates] && params[:link_designations] && params[:link_permanents] && params[:link_reason_for_leaving]
      links = params[:link_organizations].zip(params[:link_from_dates],params[:link_end_dates],params[:link_designations],params[:link_permanents],params[:link_reason_for_leaving]).
          reject { |organizations, from_dates, end_dates, designations, permanents, reason_for_leaving| organizations.blank? && from_dates.blank? && end_dates.blank? && designations.blank? && end_dates.blank? && permanents.blank? && reason_for_leaving.blank?}.
          map { |organizations, from_dates, end_dates, designations, permanents, reason_for_leaving|
        @user_work_experience = UserWorkExperience.new(:organization => organizations, :from_date => from_dates, :end_date => end_dates, :designation => designations, :permanent => permanents, :reason_for_leaving => reason_for_leaving, :user_id => @current_pseudonym[:user_id])
        @user_work_experience.save
      }
    end

    @candidate_detail = User.find_by_id(@current_pseudonym[:user_id])
    if @candidate_detail.update_attributes(params[:candidate_detail])
      flash[:success] ="Successfully Updated Settings."
      @course = Course.find(params[:course_id])
      redirect_to course_quizzes_path(@course)
    end

  end

  def comapre_and_delete(comparable1,comparable2,context_name)
    deleted_ids = comparable1 - comparable2
    deleted_ids.each do |deleted_id|
      context_name = context_name.find(deleted_id)
      context_name.destroy
    end
  end

  def send_invitation_email(context,pseudonym,user,quiz)
    domains = HostUrl.context_hosts(@domain_root_account)
    @domain_url =  "#{HostUrl.protocol}://#{domains.first}/authenticateKey/"
    m = Message.new
    m.to = pseudonym.unique_id
    m.subject = "Assessment Invitation"
    m.html_body = "You have been invited by #{@current_user.name} to take the assessment #{quiz.title}"
    m.body = @domain_url+"#{@access_code.unique_access_code}"
    Mailer.send_later(:deliver_invitation_email,m,user)
  end

end

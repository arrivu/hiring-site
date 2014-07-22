class CandidateReport < ActiveRecord::Base

  attr_accessible :user_id,:quiz_id,:attachment_id
  belongs_to :pseudonym
  belongs_to :user
  belongs_to :course
  has_many :user_academics
  has_many :quizzes
  has_many :quiz_submissions, :dependent => :destroy, :class_name => 'Quizzes::QuizSubmission'
  has_one :profile, :class_name => 'UserProfile'
  delegate :short_name, :name, :asset_string, :opaque_identifier, :to => :user
  alias :orig_profile :profile

  has_many :file_attachments, :class_name => "Attachment"
  has_many :attachments, :as => :context, :dependent => :destroy
  require 'action_controller_test_process'


  def self.generate_view(student_ids,data,quiz_id,current_user,context)
    @user_select_id = student_ids
    @check_pdf_options = {:allow_personal_detail => data[:allow_personal_detail], :allow_academic_detail => data[:allow_academic_detail],
                          :allow_employment_detail => data[:allow_employment_detail], :allow_assessment_detail => data[:allow_assessment_detail],
                          :allow_image_proctoring => data[:allow_image_proctoring]}
    @users = []
    @users_full_array = []
    @user_select_id.each do |user_id|
      @candidate_detail = User.find_by_id(user_id)

      #@user_image_profile = Attachment.find_by_user_id_and_context_type_and_file_state(user_id,"User","available")
      @profile_pic = self.show_image_profile(user_id)
      @get_pseudonym = Pseudonym.find_by_user_id(user_id)
      @quiz = Quizzes::Quiz.find(quiz_id)
      @assignment = @quiz.assignment
      @submission = @quiz.quiz_submissions.find_by_user_id(user_id, :order => 'created_at') rescue nil
      @quiz_stored = @quiz.stored_questions
      @image_proctoring = show_image_select_user(user_id,@quiz.id)
      @user_data = UserAcademic.find_all_by_user_id(user_id)
      @user_experience = UserWorkExperience.find_all_by_user_id(user_id)
      @users_full_array = {:candidate_detail => @candidate_detail, :get_pseudonym => @get_pseudonym,:quiz => @quiz, :assignment => @assignment,
                           :submission => @submission, :quiz_stored => @quiz_stored, :image_proctoring=> @image_proctoring, :user_data => @user_data,
                           :user_experience => @user_experience, :profile_pic => @profile_pic}
      @users <<  @users_full_array
    end

      begin
        # create an instance of ActionView, so we can use the render method outside of a controller
        av = ActionView::Base.new()
        #av =  ActionView::Base.send(:define_method, :protect_against_forgery?) { false }
        av.view_paths = ActionController::Base.view_paths << 'app/views/candidate_reports'
        # need these in case your view constructs any links or references any helper methods.
        av.class_eval do
          if CANVAS_RAILS2
            include ActionController::UrlWriter
          else
            include Rails.application.routes.url_helpers
          end
          include ApplicationHelper
          include QuizzesHelper
          include SearchTermHelper
          include HtmlTextHelper
        end
        pdf_html = av.render(:file => 'candidate_reports/generate_view', :locals => {:users => @users, :check_pdf_options => @check_pdf_options, :context => context})
        logger.info("Success")
        pdf_file_name = "#{Time.now}_candidate_report.pdf"
        doc_pdf = WickedPdf.new.pdf_from_string(pdf_html)
        pdf_path = Rails.root.join('tmp', "#{pdf_file_name}")
        File.open(pdf_path, 'wb') do |file|
          file << doc_pdf
          report_attach(pdf_file_name,pdf_path,current_user,context)
        end
      rescue => e
        logger.error("Error while running candidate_report:#{e.message}")
      end
  end
  #handle_asynchronously :generate_view, :priority => Delayed::LOW_PRIORITY, :max_attempts => 1


  def self.report_attach(pdf_file_name,pdf_path,current_user,context)
    filename = pdf_file_name
    filetype = 'application/pdf'
    @attachment = Attachment.new
    @attachment.uploaded_data = Rack::Test::UploadedFile.new(pdf_path.to_s, filetype, true)
    @attachment.display_name = filename
    @attachment.user = current_user
    @attachment.context = context
    @attachment.file_state = 'available'
    @attachment.save!
    @attachment
    @candidate_report = CandidateReport.new
    @candidate_report.quiz_id = @quiz.id
    @candidate_report.user_id = current_user.id
    @candidate_report.attachment_id = @attachment.id
    @candidate_report.save!
    pdf_path.unlink
  end

  def self.show_image_profile(user_id)
    @user_image_profile = Attachment.find_by_user_id_and_context_type_and_file_state(user_id,"User","available")
    @profile_pic = File.dirname(@user_image_profile.full_filename) + "/" + @user_image_profile.filename unless @user_image_profile.nil?
  end

  def self.show_image_select_user(user_id,quiz_id)
    @image_snap = []
    @image_snap_proctoring = []
    @image = Imageproctoring.find_all_by_user_id_and_quiz_id(user_id,quiz_id)
    @image.each do |image_shot|
      @time_elapsed = image_shot.time_elapsed
      @image_attach_id = image_shot.attachment_id
      @find_image = Attachment.find_by_id(@image_attach_id)
      @image_proctor = File.dirname(@find_image.full_filename) + "/" + @find_image.filename unless @find_image.nil?
      @image_snap <<  {:image_url => @image_proctor, :image_time => @time_elapsed}
    end
    @image_snap_proctoring << @image_snap
  end

  def self.report_pdf(student_ids,data,quiz_id)
    CandidateReport.send_later(:generate_view,student_ids,data,quiz_id)
  end

end

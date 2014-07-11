class CandidateReport < ActiveRecord::Base
  #attr_accessible :report_type,:user
  belongs_to :pseudonym
  belongs_to :user
  belongs_to :course
  has_many :user_academics
  has_many :quizzes
  has_many :quiz_submissions, :dependent => :destroy, :class_name => 'Quizzes::QuizSubmission'
  has_one :profile, :class_name => 'UserProfile'
  delegate :short_name, :name, :asset_string, :opaque_identifier, :to => :user
  alias :orig_profile :profile

  has_one :csv_attachment, :class_name => 'Attachment', :as => 'context',
          :dependent => :destroy
  has_one :progress, :as => 'context', :dependent => :destroy


  def generate_pdf

    build_csv_attachment(:display_name => "candidate_report",
                         :uploaded_data => StringIO.new(generate_view.to_pdf)
    ).tap { |a|
      a.content_type = 'application/pdf'
      a.save!
      complete_progress
    }
  end

  def complete_progress
    progress.complete
    progress.save!
  end


end

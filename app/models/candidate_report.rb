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

end

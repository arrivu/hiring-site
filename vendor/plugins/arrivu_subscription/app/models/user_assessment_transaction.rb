class UserAssessmentTransaction < ActiveRecord::Base
  include SubscriptionHelper
  belongs_to :account
  belongs_to :user
  has_many :quiz
  has_many :quiz_submissions, :dependent => :destroy, :class_name => 'Quizzes::QuizSubmission'
  attr_accessible :user_id,:context_id,:context_type,:submission_id,:quiz_id,:transaction_amount
end
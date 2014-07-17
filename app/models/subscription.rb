class Subscription < ActiveRecord::Base
  attr_accessible :name,:organization,:subdomain,:title,:email,:phone,:organization_type,:organization_size,:current_lms,:agree
  validates_presence_of :name ,:email,:organization,:subdomain,:phone
  validates_acceptance_of :agree, :allow_nil => false
  validates_length_of :name, :maximum => 30
  validates_uniqueness_of :email, :case_sensitive => false
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of :email, :with => VALID_EMAIL_REGEX,
                      :message => "Invalid Email"
  validates_length_of :organization,:maximum => 30
  validates_length_of :subdomain, :minimum => 3
  validates_length_of :subdomain,:maximum => 20
  has_many :subscription_account_settings
  has_many :subscription_messages

  HUMANIZED_ATTRIBUTES = {
      :subdomain => "Domain",
      :agree     => "Terms of Service"
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
end

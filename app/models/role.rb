#
# Copyright (C) 2012 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

class Role < ActiveRecord::Base
  belongs_to :account
  belongs_to :root_account, :class_name => 'Account'
  attr_accessible :name
  before_validation :infer_root_account_id
  validates_presence_of :name
  validates_inclusion_of :base_role_type, :in => RoleOverride::BASE_ROLE_TYPES, :message => 'is invalid'
  validates_exclusion_of :name, :in => RoleOverride::KNOWN_ROLE_TYPES + Enrollment::SIS_TYPES.values
  validates_uniqueness_of :name, :scope => :account_id
  validate :ensure_no_name_conflict_with_different_base_role_type

  def infer_root_account_id
    unless self.account
      self.errors.add(:account_id)
      return false
    end
    self.root_account_id = self.account.root_account_id || self.account.id
  end

  def ensure_no_name_conflict_with_different_base_role_type
    if self.root_account.all_roles.not_deleted.scoped(:conditions => ["name = ? AND base_role_type <> ?", self.name, self.base_role_type]).any?
      self.errors.add(:name, 'is already taken by a different type of Role in the same root account')
    end
  end

  include Workflow
  workflow do
    state :active do
      event :deactivate, :transitions_to => :inactive
    end
    state :inactive do
      event :activate, :transitions_to => :active
    end
    state :deleted
  end

  def account_role?
    base_role_type == AccountUser::BASE_ROLE_NAME
  end

  def course_role?
    !account_role?
  end

  alias_method :destroy!, :destroy
  def destroy
    self.workflow_state = 'deleted'
    self.deleted_at = Time.now
    save!
  end

  named_scope :not_deleted, :conditions => ['roles.workflow_state != ?', 'deleted']
  named_scope :deleted, :conditions => ['roles.workflow_state = ?', 'deleted']
  named_scope :active, :conditions => ['roles.workflow_state = ?', 'active']
  named_scope :inactive, :conditions => ['roles.workflow_state = ?', 'inactive']
  named_scope :for_courses, :conditions => ['roles.base_role_type != ?', AccountUser::BASE_ROLE_NAME]
  named_scope :for_accounts, :conditions => ['roles.base_role_type = ?', AccountUser::BASE_ROLE_NAME]

  def self.is_base_role?(role_name)
    RoleOverride.base_role_types.include?(role_name)
  end

  # Returns a list of hashes for each base enrollment type, and each will have a
  # custom_roles key, each will look like:
  # [{:base_role_name => "StudentEnrollment",
  #   :name => "StudentEnrollment",
  #   :label => "Student",
  #   :plural_label => "Students",
  #   :custom_roles =>
  #           [{:base_role_name => "StudentEnrollment",
  #             :name => "weirdstudent",
  #             :asset_string => "role_4"
  #             :label => "weirdstudent"}]},
  # ]
  def self.all_enrollment_roles_for_account(account, include_inactive=false)

    custom_roles = account.available_course_roles_by_name(include_inactive).values
    RoleOverride::ENROLLMENT_TYPES.map do |br|
      new = br.clone
      new[:label] = br[:label].call
      new[:plural_label] = br[:plural_label].call
      new[:custom_roles] = custom_roles.select{|cr|cr.base_role_type == new[:base_role_name]}.map do |cr|
        {:base_role_name => cr.base_role_type, :name => cr.name, :label => cr.name, :asset_string => cr.asset_string, :workflow_state => cr.workflow_state}
      end
      new
    end
  end

  # returns same hash as all_enrollment_roles_for_account but adds enrollment
  # counts for the given course to each item
  def self.custom_roles_and_counts_for_course(course, user, include_inactive=false)
    users_scope = course.users_visible_to(user)
    base_counts = users_scope.count(:distinct => true, :group => 'enrollments.type', :select => 'users.id', :conditions => 'enrollments.role_name IS NULL')
    role_counts = users_scope.count(:distinct => true, :group => 'enrollments.role_name', :select => 'users.id', :conditions => 'enrollments.role_name IS NOT NULL')

    @enrollment_types = Role.all_enrollment_roles_for_account(course.account, include_inactive)
    @enrollment_types.each do |base_type|
      base_type[:count] = base_counts[base_type[:name]] || 0
      base_type[:custom_roles].each do |custom_role|
        custom_role[:count] = role_counts[custom_role[:name]] || 0
      end
    end

    @enrollment_types
  end

  def self.built_in_role_names
    @built_in_role_names ||= %w(AccountAdmin) + Enrollment.valid_types
  end

  # this is designed to be used in place of a Role for the purpose
  # of displaying built-in roles alongside custom ones.
  # it implements name, base_role_type, and workflow_state
  class BuiltInRole
    attr_accessor :name

    def self.create(name)
      return nil unless Role.built_in_role_names.include?(name)
      r = BuiltInRole.new
      r.name = name
      r
    end

    def base_role_type
      (@name == 'AccountAdmin') ? 'AccountMembership' : @name
    end

    def workflow_state
      'active'
    end
  end

  # returns a BuiltInRole for the role with the given name, or nil
  # if the role is not a built-in-role
  def self.built_in_role(role_name)
    return nil unless self.built_in_role_names.include?(role_name)
    @built_in_roles ||= {}
    @built_in_roles[role_name] ||= BuiltInRole.create(role_name)
  end

  # returns an array of all built-in Roles
  def self.built_in_roles
    @all_built_in_roles ||= self.built_in_role_names.map{ |brt| Role.built_in_role(brt) }
  end
end

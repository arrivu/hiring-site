#
# Copyright (C) 2013 Instructure, Inc.
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

class CiscoWebexConference < WebConference

  user_setting_field :external_emails, {
    name: ->{ t('external_emails_setting', 'External Emails') },
    description: ->{ t('external_emails_setting_description', 'External emails') },
    type: :text,
    visible: true,
    default: "",
    location: 'members'
  }

  # Public: Start a new conference and return its key. (required by WebConference)
  #
  # Returns a meeting.
  def initiate_conference
    unless self.conference_key.present?
      options = {}
      options[:duration] = self.duration || 999999
      options[:emails] = settings[:external_emails].nil? ? [] : settings[:external_emails].strip.split(';')
      webex_meeting = CanvasWebex::Meeting.create(self.title, options)
      self.conference_key = webex_meeting.meeting_key
      save
    end
    self.conference_key
  end

  # Public: Determine the status of the conference (required by WebConference).
  #
  # Returns conference status as a symbol (either :active or :closed).
  def conference_status
    if self.started_at.nil?
      :created
    elsif meeting && self.ended_at.nil?
      :active
    else
      unless self.ended_at
        self.close
        self.end_at = self.ended_at
        self.save
      end
      :closed
    end
  end

  # Public: Add an admin to the conference and create a meeting URL (required by WebConference).
  #
  # admin - The user to add to the conference as an admin.
  # _ - Included for compatibility w/ web_conference.rb
  #
  # Returns a meeting URL string.
  def admin_join_url(admin, _ = nil)
    if meeting
      meeting.host_url
    end
  end

  # Public: Add a participant to the conference and create a meeting URL.
  #         Make the user a conference admin if they have permissions to create
  #         a conference (required by WebConference).
  #
  # user - The user to add to the conference as an admin.
  # _ - Included for compatibility w/ web_conference.rb
  #
  # Returns a meeting URL string.
  def participant_join_url(user, _ = nil)
    if meeting
      if grants_right?(user, nil, :initiate)
        meeting.host_url
      else
        meeting.join_url
      end
    end
  end

  # Public: List all of the recordings for a meeting
  #
  # Returns an Array of recording hashes, or an empty Array if there are no recordings
  def recordings
    CanvasWebex::Meeting.recordings(self.conference_key)
  end

  def after_find
    conference_status
  end

  protected

  def webex_client
    CanvasWebex.client
  end

  # Protected: Retrieve the meeting if it is still active
  #
  # Returns the meeting object, or nil if the meeting is ended
  def meeting
    self.conference_key && CanvasWebex::Meeting.retrieve(self.conference_key)
  end


end

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

module Canvas
  module Plugins
    class CiscoWebex

      # Public: Bootstrap the gem on app load.
      #
      # Returns nothing.
      def initialize; register; end

      protected
      # Internal: Register as a plugin with Canvas
      #
      # Returns a Canvas plugin object
      def register
        Canvas::Plugin.register('cisco_webex', :web_conferencing, {
          :name => lambda { t(:name, 'Cisco WebEx') },
          :description => lambda { t(:description, 'Cisco WebEx web conferencing support.') },
          :author => 'Instructure',
          :author_website => 'http://instructure.com',
          :version => CanvasWebex::VERSION,
          :settings_partial => 'plugins/webex_settings',
          :validator => 'CiscoWebexValidator',
          :encrypted_settings => [:password, :meeting_password]
        })
      end

    end
  end
end
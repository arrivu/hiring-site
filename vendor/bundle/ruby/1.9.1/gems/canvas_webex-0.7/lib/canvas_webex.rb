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

require_dependency "canvas_webex/version"

module CanvasWebex
  class ConnectionError < StandardError; end

  configure_method = Proc.new do
    view_path = File.join(File.dirname(__FILE__), '..', 'app', 'views')
    unless ApplicationController.view_paths.include?(view_path)
      ApplicationController.view_paths.unshift(view_path)
    end

    path = File.expand_path('../app/models', File.dirname(__FILE__))
    ActiveSupport::Dependencies.autoload_paths << path unless ActiveSupport::Dependencies.autoload_paths.include? path

    require_dependency File.expand_path('../app/models/cisco_webex_conference.rb', File.dirname(__FILE__))
    require_dependency "canvas/plugins/validators/cisco_webex_validator"
    require_dependency "canvas/plugins/cisco_webex"
    require_dependency "canvas_webex/service"
    require_dependency "canvas_webex/meeting"

    Canvas::Plugins::CiscoWebex.new
  end

  if CANVAS_RAILS2
    Rails.configuration.to_prepare(&configure_method)
  else
    class Railtie < Rails::Railtie; end
    Railtie.config.to_prepare(&configure_method)
  end

  # Public: Find the plugin configuration.
  #
  # Returns a settings hash.
  def self.config
    Canvas::Plugin.find('cisco_webex').settings || {}
  end

  # Return a cached Connect Service object to make requests with.
  #
  # Returns a CiscoWwebex::Service.
  def self.client
    Service.new(*self.config.values_at(:webex_id, :password_dec, :site_id, :site_name, :partner_id, :meeting_password_dec))
  end
end

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

require [
  'Backbone'
  'jquery'
  'str/htmlEscape'
  'compiled/tinymce'
  'jquery.instructure_forms'
  'tinymce.editor_box'
], (I18n, {View}, $, htmlEscape) ->

  class RegiterForm extends View

    el: document.body

    events:
      'click [data-event]': 'handleDeclarativeClick'
      'submit #edit_profile_form': 'validateForm'

    attemptedDependencyLoads: 0

    initialize: ->
      super

      @addQualField()
      @addWorkField()

    handleDeclarativeClick: (event) ->
      event.preventDefault()
      $target = $ event.currentTarget
      method = $target.data 'event'
      @[method]? event, $target

    ##
    # first run initializes some stuff, then is reassigned
    # to a showEditForm


    addQualField: (event, $el, title = '', url = '') ->
      @$linkFields1 ?= @$ '#qual_fields'
      $row = $ """
               <tr>
               <td><input type="text" name="link_titles[]" value="#{htmlEscape title}"></td>
               <td><input type="text" name="link_titles[]" value="#{htmlEscape title}"></td>
               <td><input type="text" name="link_titles[]" value="#{htmlEscape title}"></td>
               <td><input type="text" name="link_titles[]" value="#{htmlEscape title}"></td>
               <td><input type="text" name="link_titles[]" value="#{htmlEscape title}"></td>
               <td><a href="#" data-event="removeLinkRow"><i class="icon-end"></i></a></td>
               </tr>
               """
      @$linkFields1.append $row

      if event?
        event.preventDefault()
        $row.find('input:first').focus()

    addWorkField: (event, $el, title = '', url = '') ->
      @$linkFields2 ?= @$ '#work_fields'
      $row = $ """
               <tr>
               <td><input type="text" name="link_titles[]" value="#{htmlEscape title}"></td>
               <td><input type="text" name="link_titles[]" value="#{htmlEscape title}"></td>
               <td><input type="text" name="link_titles[]" value="#{htmlEscape title}"></td>
               <td><input type="text" name="link_titles[]" value="#{htmlEscape title}"></td>
               <td><input type="text" name="link_titles[]" value="#{htmlEscape title}"></td>
               <td><input type="text" name="link_titles[]" value="#{htmlEscape title}"></td>
               <td><a href="#" data-event="removeLinkRow"><i class="icon-end"></i></a></td>
               </tr>
               """
      @$linkFields2.append $row

      if event?
        event.preventDefault()
        $row.find('input:first').focus()


    removeLinkRow: (event, $el) ->
      $el.parents('tr').remove()






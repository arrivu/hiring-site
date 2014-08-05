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
#  'compiled/util/ProfilePicture'
  'jquery.instructure_date_and_time'
  'jquery.instructure_forms'
  'compiled/tinymce'
  'jquery.instructure_forms'
  'tinymce.editor_box'
], ({View}, $, htmlEscape) ->

  class FillRegistration extends View

    el: document.body

    events:
      'click [data-event]': 'handleDeclarativeClick'
      'submit #edit_profile_form': 'validateForm'
      'click #submitbutton': 'formValidations'

    attemptedDependencyLoads: 0

    initialize: ->
      super
#      new AvatarWidget('.profile-pic-link')
      @addQualField()
      @addWorkField()
#      @initEditUser()
      $(".date_entry").date_field(alwaysShowTime: false)
      $(".from_date").date_field(alwaysShowTime: false)
      $(".to_date").date_field(alwaysShowTime: false)


    handleDeclarativeClick: (event) ->
      event.preventDefault()
      $target = $ event.currentTarget
      method = $target.data 'event'
      @[method]? event, $target

    formValidations: (event) ->
      first_name = $("#first_name").val()
      middle_name = $("#middle_name").val()
      last_name = $("#last_name").val()
      date_of_birth = $("#date_of_birth").val()
      address = $("#address").val()
      zip_code = $("#zip_code").val()
      mobile = $("#mobile").val()
      if first_name == ""
        offset_first_name = $("#first_name").errorBox("This field is required")
        $("html,body").scrollTo
          top: offset_first_name.top
          left: 0
        $("#first_name").focus()
        return false
      if middle_name == ""
        offset_middle_name = $("#middle_name").errorBox("This field is required")
        $("html,body").scrollTo
          top: offset_middle_name.top
          left: 0
        $("#middle_name").focus()
        return false
      if last_name == ""
        offset_last_name = $("#last_name").errorBox("This field is required")
        $("html,body").scrollTo
          top: offset_last_name.top
          left: 0
        $("#last_name").focus()
        return false
      chk = document.getElementsByName("candidate_detail[gender]")
      len = chk.length
      has_program = false
      i = 0
      while i < len
        if chk[i].checked
          has_program = true
          break
        i++
      if(!has_program)
        offset_gender = $("#gender").errorBox("This field is required")
        $("html,body").scrollTo
          top: offset_gender.top
          left: 0
        unless chk[0].checked
          chk[0].focus()
        return false
      if date_of_birth == ""
        offset_date_of_birth = $("#date_of_birth").errorBox("This field is required")
        $("html,body").scrollTo
          top: offset_date_of_birth.top
          left: 0
        $("#date_of_birth").focus()
        return false
      else
        pattern = /^([0-9]{2})\-([0-9]{2})\-([0-9]{4})$/
        if !pattern.test(date_of_birth)
          offset_date_of_birth = $("#date_of_birth").errorBox("Please enter the date format as 'DD-MM-YYYY'.")
          $("html,body").scrollTo
            top: offset_date_of_birth.top
            left: 0
          $("#date_of_birth").val("")
          $("#date_of_birth").focus()
          return false
      if mobile == ""
        offset_mobile = $("#mobile").errorBox("This field is required")
        $("html,body").scrollTo
          top: offset_mobile.top
          left: 0
        $("#mobile").focus()
        return false
      else if mobile && mobile != "undefined"
        pattern = /^[0-9]+$/
        if !pattern.test(mobile)
          offset_mobile = $("#mobile").errorBox("The contact number must have numeric characters only.")
          $("html,body").scrollTo
            top: offset_mobile.top
            left: 0
          $("#mobile").val("")
          $("#mobile").focus()
          return false
      if address == ""
        offset_address = $("#address").errorBox("This field is required")
        $("html,body").scrollTo
          top: offset_address.top
          left: 0
        $("#address").focus()
        return false
      if zip_code == ""
        offset_zip_code = $("#zip_code").errorBox("This field is required")
        $("html,body").scrollTo
          top: offset_zip_code.top
          left: 0
        $("#zip_code").focus()
        return false
      else if zip_code != "undefined"
        pattern = /^[0-9]+$/
        if !pattern.test(zip_code)
          offset_zip_code = $("#zip_code").errorBox("The zip code must have numeric characters only.")
          $("html,body").scrollTo
            top: offset_zip_code.top
            left: 0
          $("#zip_code").val("")
          $("#zip_code").focus()
          return false

        ##
    # first run initializes some stuff, then is reassigned
    # to a showEditForm
    editProfile: ->
      @initEdit()
      @editProfile = @showEditForm

    showEditForm: ->
      @$el.addClass('editing').removeClass('not-editing')
      @$('.profile_links').removeClass('span6')

    initEditUser: ->
      if @options.links?.length
        @addQualField(null, null, degree, discipline, college, year_of_completion, percentage) for {degree, discipline, college, year_of_completion, percentage} in @options.links
      else
        @addQualField()

    initEdit: ->
      if @options.links?.length
        @addLinkField(null, null, title, url) for {title, url} in @options.links
      else
        @addLinkField()
        @addLinkField()

      # setTimeout so tiny has some width to read
      #setTimeout -> @$('#profile_bio').editorBox()
      @showEditForm()

    cancelEditProfile: ->
      @$el.addClass('not-editing').removeClass('editing')
#      @$('.profile_links').addClass('span6')

    ##
    # Event handler that can also be called manually.
    # When called manually, it will focus the first input in the new row
    addLinkField: (event, $el, title = '', url = '') ->
      @$linkFields ?= @$ '#profile_link_fields'
      $row = $ """
               <tr>
               <td><input type="text" maxlength="255" name="link_titles[]" value="#{htmlEscape title}"></td>
               <td>→</td>
               <td><input type="text" name="link_urls[]" value="#{htmlEscape url}"></td>
               <td><a href="#" data-event="removeLinkRow"><i class="icon-end"></i></a></td>
               </tr>
               """
      @$linkFields.append $row

      if event?
        event.preventDefault()
        $row.find('input:first').focus()

    addQualField: (event, $el, degree = '', discipline = '', college = '', year_of_completion = '', percentage = '') ->
      @$linkFields1 ?= @$ '#qual_fields'
      $row = $ """

        <tr>
         <td><input type="text" name="link_degrees[]" value="#{htmlEscape degree}"></td>
         <td><input type="text" name="link_disciplines[]" value="#{htmlEscape discipline}"></td>
         <td><input type="text" name="link_colleges[]" value="#{htmlEscape college}"></td>
         <td><input type="text" name="link_year_of_completions[]" value="#{htmlEscape year_of_completion}"></td>
         <td><input type="text" name="link_percentages[]" value="#{htmlEscape percentage}"></td>
         <td><a href="#" data-event="removeLinkRow"><i class="icon-end"></i></a></td>
         </tr>
         """
      @$linkFields1.append $row

      if event?
        event.preventDefault()
        $row.find('input:first').focus()

    addWorkField: (event, $el, organization = '', from_date = '', end_date = '', designation = '', permanent = '', reason_for_leaving = '') ->
      $(".from_date").date_field(alwaysShowTime: false)
      $(".to_date").date_field(alwaysShowTime: false)
      @$linkFields2 ?= @$ '#work_fields'
      $row = $ """

         <tr>
         <td><input type="text" name="link_organizations[]" value="#{htmlEscape organization}"></td>
         <td><input type="text" name="link_from_dates[]" value="#{htmlEscape from_date}" placeholder="DD-MM-YYYY" style="width:80%;"></td>
         <td><input type="text" name="link_end_dates[]" value="#{htmlEscape end_date}" placeholder="DD-MM-YYYY" style="width:80%;"></td>
         <td><input type="text" name="link_designations[]" value="#{htmlEscape designation}"></td>
         <td><input type="text" name="link_permanents[]" value="#{htmlEscape permanent}"></td>
         <td><input type="text" name="link_reason_for_leaving[]" value="#{htmlEscape reason_for_leaving}"></td>
         <td><a href="#" data-event="removeLinkRow"><i class="icon-end"></i></a></td>
         </tr>
         """

      @$linkFields2.append $row

      if event?
        event.preventDefault()
        $row.find('input:first').focus()


    removeLinkRow: (event, $el) ->
      $el.parents('tr').remove()

#    validateForm: (event) ->
#      validations =
#        required: ['user[short_name]']
#        property_validations:
#          'user_profile[title]': (value) ->
#            if value && value.length > 255
#              return I18n.t("profile_title_too_long", "Title is too long")
#      if !$(event.target).validateForm(validations)
#        event.preventDefault()

  new FillRegistration ENV.PROFILE

define [
  'i18n!roster'
  'Backbone'
  'jquery'
  'str/htmlEscape'
  'jst/CandidateInvitations/IndexView'
  'compiled/views/ValidatedMixin'
  'compiled/jquery.rails_flash_notifications'
], (I18n,Backbone, $, htmlEscape, template, ValidatedMixin) ->

  class IndexView extends Backbone.View

    @mixin ValidatedMixin

    @child 'candidateView', '[data-view=candidateView]'

    @child 'inputFilterView', '[data-view=inputFilter]'

    @child 'sectionSelectView', '[data-view=sectionSelect]'

    @optionProperty 'sections'

    template: template

    events:
      'click #send_all_invitations': 'sendInvitations'
      'click .check-id': 'unSelectCheckbox'

    attach: ->
      @collection.on 'setParam deleteParam', @fetch
      @candidateView.on 'close', @fetchOnCreateUsersClose

    fetchOnCreateUsersClose: =>
      @collection.fetch() if @candidateView.hasUsers()

    fetch: =>
      @lastRequest?.abort()
      @lastRequest = @collection.fetch().fail @onFail

    toJSON: -> this

    unSelectCheckbox: (event)->
      state = (if $(event.currentTarget).attr("checked") is "checked" then true else false)
      if state is false
        $(event.currentTarget).removeAttr "checked"
      else
        $(event.currentTarget).attr "checked", "checked"

    sendInvitations: ->
      values = new Array()
      $.each $("input[name='chkbox[]']:checked").closest("td").siblings("td"), ->
        values.push $(this).text()
        return

      str = values.join(",")
      myarray = str.split(",")
      email_array = new Array()
      i = 0

      while i < myarray.length
        email_array.push myarray[i]  if (i % 2)!=0
        i++
      login_id = email_array
      @collection.create
        login_ids: login_id
        type: "POST"
      ,
        silent: true
        success: (response) ->
          $.flashMessage "Invitations send Successfully!"

        error: (response) ->
          $.flashMessage "There is some error while saving reward! " + response
      return false

    onFail: (xhr) =>
      return if xhr.statusText is 'abort'
      parsed = $.parseJSON xhr.responseText
      message = if parsed?.errors?[0].message is "3 or more characters is required"
        I18n.t('greater_than_three', 'Please enter a search term with three or more characters')
      else
        I18n.t('unknown_error', 'Something went wrong with your search, please try again.')
      @showErrors search_term: [{message}]






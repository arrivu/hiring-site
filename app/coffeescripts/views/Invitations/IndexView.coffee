define [
  'jquery'
  'i18n!rewards'
  'str/htmlEscape'
  'jst/invitations/IndexView'
  'compiled/views/Invitations/PersonelCollectionView'
  'compiled/views/Invitations/AcademicsCollectionView'
#  'compiled/views/Invitations/ExperienceCollectionView'
  'compiled/models/Personel'
  'compiled/models/Academics'
  'compiled/views/Invitations/AcademicsView'
#  'compiled/models/Experience'
], ($, I18n, htmlEscape, template, PersonelCollectionView, Personel, AcademicsCollectionView, Academics, AcademicsView) ->

  class IndexView extends Backbone.View

#    @child 'academicsCollectionView', '[data-view=academicView]'

    template: template
    className: 'index_view'
    events:
      'click #add_academics': 'addQualField'
      'click #register_submit': 'validateForm'

#    personelView = new PersonelCollectionView
#      collection: @personelCollection
#      el: '.index_view_personel'
#    personelView.render()

    validateForm: (event) ->
      arr = []
      $(".table-personal-view tr td").each ->
        if $("#txtItemCode", $(this)).val()
          ItemCode = $("#txtItemCode", $(this)).val()
          ItemText = $("#txtItemCode", $(this)).attr("name")
          obj = {}
          obj[ItemText] = ItemCode
          arr.push obj

      console.log(arr)
      $.post "optional_register",
        personel_detail: arr

    addQualField: (event, $el, title = '', url = '') ->
      @$linkFields1 ?= @$ '#qual_fields'
      $row = $ """
         <tr>
         <td><input type="text" name="degree[]" id="degree" value="#{htmlEscape title}"></td>
         <td><input type="text" name="discipline[]" id="discipline" value="#{htmlEscape title}"></td>
         <td><input type="text" name="college[]" id="college" value="#{htmlEscape title}"></td>
         <td><input type="text" name="year[]" id="year" value="#{htmlEscape title}"></td>
         <td><input type="text" name="percentage[]" id="percentage" value="#{htmlEscape title}"></td>
         <td><a href="#" data-event="removeLinkRow"><i class="icon-end"></i></a></td>
         </tr>
         """
      @$linkFields1.append $row

      if event?
        event.preventDefault()
        $row.find('input:first').focus()

#    addAcademics: (event) ->
#      alert("Ok")
#      @attach_onclick
#
#    attach_onclick: ->
#      academicsview = new AcademicsView
#        collection: @academicsCollection
#        el: '#qual_fields'
#      academicsview.render()


#    attach: ->
#      @academicscollection.on 'setParam deleteParam', @fetch
#      @academicsCollectionView.on 'close'
#
#    fetchOnCreateUsersClose: =>
#      @collection.fetch() if @academicsCollectionView.hasUsers()
#
#    fetch: =>
#      @lastRequest?.abort()
#      @lastRequest = @academicscollection.fetch().fail @onFail
#
#    toJSON: -> this
#
#    onFail: (xhr) =>
#      return if xhr.statusText is 'abort'
#      parsed = $.parseJSON xhr.responseText
#      message = if parsed?.errors?[0].message is "3 or more characters is required"
#        I18n.t('greater_than_three', 'Please enter a search term with three or more characters')
#      else
#        I18n.t('unknown_error', 'Something went wrong with your search, please try again.')
#      @showErrors search_term: [{message}]
#


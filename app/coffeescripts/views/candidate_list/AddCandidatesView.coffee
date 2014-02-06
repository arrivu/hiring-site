define [
  'jquery'
  'underscore'
  'Backbone'
  'jst/candidate_list/AddCandidates'
  'compiled/jquery/fixDialogButtons'
], ($,_, Backbone, template, AddCandidatesItemView) ->

  class AddCandidatesView extends Backbone.View

    template: template
    className: 'candidate_list'

    events:
      'click #select_all' : "checkAll"

    afterRender: ->
      @$el.dialog
        title: 'Add candidates from project'
        width: 800
        height: "auto"
        resizable: true
        buttons: [
          class: "btn-primary"
          text:  'Submit'
          'data-text-while-loading': 'Saving...'
          click: => @submit()
        ]

    submit: ->
      this.$el.parent().find('.btn-primary').removeClass('ui-state-hover')
      super



    checkAll: (event) ->

      checkboxes = new Array()
      checkboxes = document.getElementsByName("chkbox[]")
      arrMarkMail = document.getElementsByName("chkbox[]")

      i = 0

      while i < arrMarkMail.length
        value=document.getElementById("selectall").checked
        alert(value)
        if value == true
          alert("Ok if")
          arrMarkMail[i].setAttribute "checked", true  if checkboxes[i].type is "checkbox"
        else
          alert("Ok else")
          arrMarkMail[i].setAttribute "checked",false  if checkboxes[i].type is "checkbox"
        i++
      return




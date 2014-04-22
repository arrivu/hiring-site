define [
  'i18n!overrides'
  'Backbone'
  'underscore'
  'jst/assignments/DueDateView'
  'jquery'
  'jquery.toJSON'
  'jquery.instructure_date_and_time'
  'jquery.instructure_forms'
], (I18n,Backbone, _, template, $) ->
  class DueDateView extends Backbone.View
    template: template
    tagName: 'li'
    className: 'due-date-row'

    events:
      'click .remove-link' : 'removeDueDate'
      'click #quiz_show_correct_answers' : 'QuizShowCorrectOption'

    # Method Summary
    #  Apply bindings and calendar js to each view
    afterRender: =>
      @$el.find('.date_field').datetime_field()

    # Method Summary
    #   Removes a due date override from the collection when clicked. Find the
    #   specific due date and remove it.
    # @api private
    removeDueDate: (event) =>
      event.preventDefault()
      @trigger 'remove', @model
      @remove()

    QuizShowCorrectOption: (event) =>
      event.preventDefault()
      alert($(event.currentTarget).id("quiz_show_correct_answers"))

    hideRemoveButton: =>
      @$el.find('.remove-link').hide()

    showRemoveButton: =>
      @$el.find('.remove-link').show()

    reRenderSections: (sections) =>
      _.each @options.views, (view) ->
        view.sections = sections
        view.render()

    getFormValues: =>
      json = @$el.find('form').toJSON()
      for dateField in [ 'due_at', 'lock_at', 'unlock_at', 'show_correct_answers_at', 'hide_correct_answers_at']
        json[dateField] = $.unfudgeDateForProfileTimezone(json[dateField])
      json.course_section_id = parseInt(json.course_section_id, 10)
      errs = @validateBeforeSave json, {}
      @$el.hideErrors()
      x = $("#quiz_show_correct_answers").is(":checked")
      if(x)
        json.quiz_show_answers = x
      else
        json.quiz_show_answers = json.quiz_show_answers
      for own el, msg of errs.assignmentOverrides
        @$("[name=#{el}]").errorBox msg
      json

    validateBeforeSave: (data, errors) =>
      errs = {}
      if data
          lockAt = data.lock_at
          unlockAt = data.unlock_at
          dueAt = data.due_at
          courseSectionId = data.course_section_id
          if(courseSectionId==0)
            errs.course_section_id = "Choose Batch"
          if lockAt && dueAt && lockAt < dueAt
            errs.lock_at = I18n.t('lock_date_before_due_date',
              'Lock date cannot be before due date')
          if unlockAt && dueAt && unlockAt > dueAt
            errs.unlock_at = I18n.t('unlock_date_after_due_date',
              'Unlock date cannot be after due date')
          else if unlockAt && lockAt && unlockAt > lockAt
            errs.unlock_at = I18n.t('unlock_date_after_lock_date',
              'Unlock date cannot be after lock date')
      errors['assignmentOverrides'] = errs if _.keys(errs).length > 0
      errors

    updateOverride: =>
      @model.set @getFormValues()

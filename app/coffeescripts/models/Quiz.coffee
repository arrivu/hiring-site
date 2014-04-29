define [
  'jquery'
  'underscore'
  'Backbone'
  'compiled/models/Assignment'
  'compiled/models/DateGroup'
  'compiled/collections/AssignmentOverrideCollection'
  'compiled/collections/DateGroupCollection'
  'str/pluralize'
  'i18n!quizzes'
  'jquery.ajaxJSON'
  'jquery.instructure_misc_helpers' # $.underscore
], ($, _, Backbone, Assignment, DateGroup, AssignmentOverrideCollection, DateGroupCollection, pluralize, I18n) ->

  class Quiz extends Backbone.Model
    resourceName: 'quizzes'

    defaults:
      due_at: null
      unlock_at: null
      lock_at: null
      show_correct_answers_at: null
      hide_correct_answers_at: null
      unpublishable: true
      points_possible: null

    initialize: (attributes, options = {}) ->
      super
      @initAssignment()
      @initAssignmentOverrides()
      @initUrls()
      @initTitleLabel()
      @initUnpublishable()
      @initQuestionsCount()
      @initPointsCount()
      @initAllDates()

    # initialize attributes
    initAssignment: ->
      if @attributes.assignment
        @set 'assignment', new Assignment(@attributes.assignment)

    initAssignmentOverrides: ->
      if @attributes.assignment_overrides
        overrides = new AssignmentOverrideCollection(@attributes.assignment_overrides)
        @set 'assignment_overrides', overrides, silent: true

    initUrls: ->
      if @get 'html_url'
        @set 'base_url', @get('html_url').replace(/quizzes\/\d+/, "quizzes")

#        @set 'url',           "#{@get 'base_url'}/#{@get 'id'}"
#        @set 'edit_url',      "#{@get 'base_url'}/#{@get 'id'}/edit"
        @set 'url',           "#{@get 'base_url'}"
        @set 'edit_url',      "#{@get 'base_url'}/edit"
        @set 'publish_url',   "#{@get 'base_url'}/publish"
        @set 'unpublish_url', "#{@get 'base_url'}/unpublish"

    initTitleLabel: ->
      @set 'title_label', @get('title') or @get('readable_type')

    initUnpublishable: ->
      @set('unpublishable', false) if @get('can_unpublish') == false and @get('published')

    initQuestionsCount: ->
      cnt = @get 'question_count'
      @set 'question_count_label', I18n.t('question_count', 'Question', count: cnt)

    initPointsCount: ->
      pts = @get 'points_possible'
      text = ''
      if pts && pts > 0
        text = I18n.t('assignment_points_possible', 'pt', count: pts)
      @set 'possible_points_label', text

    initAllDates: ->
      if (allDates = @get('all_dates'))?
        @set 'all_dates', new DateGroupCollection(allDates)

    # publishing

    publish: =>
      @set 'published', true
      $.ajaxJSON(@get('publish_url'), 'POST', 'quizzes': [@get 'id'])

    unpublish: =>
      @set 'published', false
      $.ajaxJSON(@get('unpublish_url'), 'POST', 'quizzes': [@get 'id'])

    disabledMessage: ->
      I18n.t('cant_unpublish_when_students_submit', "Can't unpublish if there are student submissions")

    # methods needed by views

    dueAt: (date) =>
      return @get 'due_at' unless arguments.length > 0
      @set 'due_at', date

    unlockAt: (date) =>
      return @get 'unlock_at' unless arguments.length > 0
      @set 'unlock_at', date

    lockAt: (date)  =>
      return @get 'lock_at' unless arguments.length > 0
      @set 'lock_at', date

    showCorrectAnswersAt: (date)  =>
      return @get 'show_correct_answers_at' unless arguments.length > 0
      @set 'show_correct_answers_at', date

    hideCorrectAnswersAt: (date)  =>
      return @get 'hide_correct_answers_at' unless arguments.length > 0
      @set 'hide_correct_answers_at', date

    htmlUrl: =>
      @get 'url'

    defaultDates: =>
      group = new DateGroup
        due_at:    @get("due_at")
        unlock_at: @get("unlock_at")
        lock_at:   @get("lock_at")
        show_correct_answers_at:   @get("show_correct_answers_at")
        hide_correct_answers_at:   @get("hide_correct_answers_at")

    multipleDueDates: =>
      dateGroups = @get("all_dates")
      dateGroups && dateGroups.length > 1

    allDates: =>
      groups = @get("all_dates")
      models = (groups and groups.models) or []
      result = _.map models, (group) -> group.toJSON()

    singleSectionDueDate: =>
      _.find(@allDates(), 'dueAt')?.dueAt.toISOString() || @dueAt()

    toView: =>
      fields = [
        'htmlUrl', 'multipleDueDates', 'allDates', 'dueAt', 'lockAt', 'unlockAt', 'showCorrectAnswersAt', 'hideCorrectAnswersAt', 'singleSectionDueDate'
      ]
      hash = id: @get 'id'
      for field in fields
        hash[field] = @[field]()
      hash

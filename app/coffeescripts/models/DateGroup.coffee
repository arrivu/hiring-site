define [
  'Backbone'
  'underscore'
  'jquery'
  'i18n!assignments'
], (Backbone, _, $, I18n) ->

  class DateGroup extends Backbone.Model

    defaults:
      title: I18n.t('everyone_else', 'Everyone else')
      due_at: null
      unlock_at: null
      lock_at: null
      show_correct_answers_at: null
      hide_correct_answers_at: null

    dueAt: ->
      dueAt = @get("due_at")
      if dueAt then Date.parse(dueAt) else null

    showCorrectAnswersAt: ->
      showCorrectAnswersAt = @get("show_correct_answers_at")
      if showCorrectAnswersAt then Date.parse(showCorrectAnswersAt) else null

    hideCorrectAnswersAt: ->
      hideCorrectAnswersAt = @get("hide_correct_answers_at")
      if hideCorrectAnswersAt then Date.parse(hideCorrectAnswersAt) else null

    unlockAt: ->
      unlockAt = @get("unlock_at")
      if unlockAt then Date.parse(unlockAt) else null

    lockAt: ->
      lockAt = @get("lock_at")
      if lockAt then Date.parse(lockAt) else null

    now: ->
      now = @get("now")
      if now then Date.parse(now) else new Date()


    # no lock/unlock dates
    alwaysAvailable: ->
      !@unlockAt() && !@lockAt()

    # not unlocked yet
    pending: ->
      unlockAt = @unlockAt()
      unlockAt && unlockAt > @now()

    # available and won't ever lock
    available: ->
      @alwaysAvailable() || (!@lockAt() && @unlockAt() < @now())

    # available, but will lock at some point
    open: ->
      @lockAt() && !@pending() && !@closed()

    # locked
    closed: ->
      lockAt = @lockAt()
      lockAt && lockAt < @now()


    toJSON: ->
      dueFor: @get("title")
      dueAt: @dueAt()
      unlockAt: @unlockAt()
      lockAt: @lockAt()
      showCorrectAnswersAt: @showCorrectAnswersAt()
      hideCorrectAnswersAt: @hideCorrectAnswersAt()
      available: @available()
      pending: @pending()
      open: @open()
      closed: @closed()
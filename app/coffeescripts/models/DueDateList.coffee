define [
  'Backbone'
  'underscore'
  'i18n!overrides'
  'compiled/models/AssignmentOverride'
  'compiled/models/Section'
], ({Model}, _, I18n, AssignmentOverride, Section) ->

  class DueDateList

    constructor: (@overrides, @sections, @assignment) ->
      if @assignment?
        # if we don't have an override for each real section
        if @overrides.length < @sections.length
          override = AssignmentOverride.defaultDueDate
            due_at: @assignment.get( 'due_at' )
            lock_at: @assignment.get( 'lock_at' )
            unlock_at: @assignment.get( 'unlock_at' )
            show_correct_answers_at: @assignment.get( 'show_correct_answers_at' )
            hide_correct_answers_at: @assignment.get( 'hide_correct_answers_at' )
          @overrides.add override
        @sections.add Section.defaultDueDateSection()
      @updateDefaultDueDateSection()
      @overrides.on 'add', @updateDefaultDueDateSection
      @overrides.on 'remove', @updateDefaultDueDateSection

    updateDefaultDueDateSection: =>
      section = @findDefaultDueDateSection()
#      if section?
#        if @overrides.length <= 1
#          section.set 'name', I18n.t('overrides.everyone','Everyone'),
#            silent: true
#        else
#          section.set 'name', I18n.t('overrides.everyone_else','Everyone Else'),
#            silent: true

    findDefaultDueDateSection: =>
      @sections.detect ( section ) ->
        section.id is Section.defaultDueDateSectionID

    getDefaultDueDate: =>
      @overrides.getDefaultDueDate()

    availableSections: =>
      overrideSectionIDs = @overrideSectionIDs()
      @sections.reject ( section ) ->
        section.id in overrideSectionIDs

    availableSectionsPlusOverride: (override, available=@availableSections()) =>
      section = @sections.detect ( section ) ->
        section.id is override.get('course_section_id')
      if section?
        available.concat(section)
      else
        available
    
    addOverride: ( override ) => @overrides.add override

    removeOverride: ( override ) => @overrides.remove override

    overrideSectionIDs: => @overrides.courseSectionIDs()

    containsSectionsWithoutOverrides: =>
      return false if @overrides.containsDefaultDueDate()
      @sectionsWithOverrides().length != @_sectionsLength()

    _sectionsLength: =>
      if @assignment?
        # to account for default section
        @sections.length - 1
      else
        @sections.length

    sectionIDs: => @sections.ids()

    containsBlankOverrides: =>
      @blankOverrides().length > 0

    blankOverrides: =>
      @overrides.blank()

    sectionsWithOverrides: =>
      @sections.select ( section ) =>
        section.id in @overrideSectionIDs() and
          section.id isnt Section.defaultDueDateSectionID

    sectionsWithoutOverrides: =>
      @sections.select ( section ) =>
        section.id not in @overrideSectionIDs() and
          section.id isnt Section.defaultDueDateSectionID

    toJSON: =>
      overrides: @overrides.toJSON()
      sections: @sections.toJSON()


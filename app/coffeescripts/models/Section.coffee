define ['Backbone', 'i18n!overrides'], ({Model}, I18n ) ->

  class Section extends Model
    @defaultDueDateSection: ->
      new Section
        id: Section.defaultDueDateSectionID
#        name: I18n.t 'overrides.everyone', 'Everyone'

    @defaultDueDateSectionID: '0'

    isDefaultDueDateSection: =>
      @id is Section.defaultDueDateSectionID

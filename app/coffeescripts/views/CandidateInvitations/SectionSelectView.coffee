define [
  'compiled/views/SelectView',
  'jst/CandidateInvitations/sectionSelect'
], (SelectView, template) ->

  class SectionSelectView extends SelectView
    @optionProperty 'sectionsCollection'
    template: template

    attach: ->
      @sectionsCollection.on 'add reset remove change', @render

    toJSON: ->
      roles: @sectionsCollection.toJSON()
      selectedRole: if @el.selectedOptions?.length
        this.el.selectedOptions[0].value
      else
        ""

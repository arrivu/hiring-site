define [
  'jquery'
  'jst/CandidateInvitations/CandidateView'
], ($, template) ->

  class CandidateView extends Backbone.View

    template: template
    tagName: 'tr'
    className: 'candidate_item'

    afterRender: ->
      @$el.attr('id', 'candidate_' + @model.get('id'))
      this


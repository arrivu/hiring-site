define [
  'underscore'
  'Backbone'
  'jst/candidate_list/AddCandidatesItem'
], (_, Backbone, template) ->

  class AddCandidatesItemView extends Backbone.View

    template: template
    tagName: 'tr'

    initialize: ->
      super
      @name = @options.name if @options.name
      @email = @options.email if @options.email

    toJSON: ->
      json = super

      json['name'] = @name
      json['email'] = @email


      json

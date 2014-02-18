define [
  'underscore'
  'Backbone'
  'jst/candidate_list/AddCandidatesItem'
], (_, Backbone, template) ->

  class AddCandidatesItemView extends Backbone.View

    template: template
    tagName: 'tr'
    el: '.candidate_list_items'

    events:
      'click .check-id': 'unSelectCheckbox'

    unSelectCheckbox: (event)->
      state = (if $(event.currentTarget).attr("checked") is "checked" then true else false)
      if state is false
        $(event.currentTarget).removeAttr "checked"
      else
        $(event.currentTarget).attr "checked", "checked"

#    initialize: ->
#      super
#      @name = @options.name if @options.name
#      @email = @options.email if @options.email
#      @pseudonymId = @options.pseudonymId if @options.pseudonymId

    toJSON: ->
      json = super

      json['name'] = @name
      json['email'] = @email
      json['pseudonym_id'] = @pseudonymId

      json

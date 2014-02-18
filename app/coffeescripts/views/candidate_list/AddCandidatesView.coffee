define [
  'jquery'
  'underscore'
  'Backbone'
  'jst/candidate_list/AddCandidates'
  'compiled/views/candidate_list/AddCandidatesItemView'
  'compiled/collections/CandidateCollection'
  'compiled/jquery/fixDialogButtons'
], ($,_, Backbone, template, AddCandidatesItemView,CandidateCollection) ->

  class AddCandidatesView extends Backbone.View

    template: template
    className: 'candidate_list_items'

    onCollectionSync: (collection) ->
      for model in collection.models
        candidate_name = model.attributes.user.name
        console.log(model.attributes.user.pseudonyms)
        for pseudonym in model.attributes.user.pseudonyms
          candidate_email = pseudonym.pseudonym.unique_id
          addCandidatesItemView = new AddCandidatesItemView
            name: candidate_name
            email: candidate_email
          $('.candidate_list_items').append(addCandidatesItemView.render().el)

    afterRender: ->
      @$el.dialog
        title: 'Candidates selected to send invitations'
        width: 800
        height: "auto"
        resizable: true
        buttons: [
          class: "btn-success send_invitation_confirm"
          text:  'Confirm'
          'data-text-while-loading': 'Sending Invitations...'
#          click: => @submit()
        ]
        console.log(@collection)
        @collection.on 'sync', @onCollectionSync,@collection


#          $('.candidate_list_items').append(addCandidatesItemView.render().el)


#    renderHeader: ->
#      @$el.find('thead tr').html "<th>Candidate Name</th><th>Candidate Email</th>"
#      @$('#candidate_list').append view.render().el
#
#    renderTable: =>
#      console.log(@collection)
#      for model in @collection.models
#        candidate_name = model.attributes.user.name
#        console.log(model.attributes.user.pseudonyms)
#        for pseudonym in model.attributes.user.pseudonyms
#          candidate_email = pseudonym.pseudonym.unique_id
#          addCandidatesItemView = new AddCandidatesItemView
#            name: candidate_name
#            email: candidate_email
#          $('.candidate_list_items').append(addCandidatesItemView.render().el

#          @$el.find("tr")
#          .last()
#          .append addCandidatesItemView.render().el

#        @collection.each (module) =>
#          modulePermissionButtonView = new ModulePermissionButtonView
#            model: module
#            user_id: enrolled_user.id
#            user_enrolled: @check_permission(module.id,enrolled_user.id)
#
#          @$el.find("tr")
#          .last()
#          .append modulePermissionButtonView.render().el




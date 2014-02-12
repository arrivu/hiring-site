define [
  'underscore'
  'Backbone'
  'jst/candidate_list/IndexView'
  'compiled/collections/CandidateCollection'
  'compiled/views/candidate_list/AddCandidatesView'
  'compiled/views/candidate_list/AddCandidatesItemView'
], (_, Backbone, template, CandidateCollection, AddCandidatesView, AddCandidatesItemView) ->

  class IndexView extends Backbone.View

    template: template
    className: 'candidate_list_items'
    events:
      'click .send_invitation': 'sendInvitations'
      'click .send_invitation_confirm': 'sendInvitationConfirm'


    $(".send_invitation").click (event) ->
      event.preventDefault();
      quiz_id=$(event.currentTarget).attr("data-id")
      course_id=$(event.currentTarget).attr("data-course-id")
      candidateCollection = new CandidateCollection
      candidateCollection.on 'sync', @getCandidateItem,candidateCollection
      candidateCollection.url = "/api/v1/courses/"+course_id+"/quizzes/"+quiz_id+"/invitations"
      candidateCollection.fetch()
      addCandidatesView = new AddCandidatesView
        collection: candidateCollection
        el: '#render_popup'
      addCandidatesView.render()

#    getCandidateItem: (collection)  ->
#      console.log(collection)
#
#      for model in collection.models
#        candidate_name = model.attributes.user.name
#        console.log(model.attributes.user.pseudonyms)
#        for pseudonym in model.attributes.user.pseudonyms
#          candidate_email = pseudonym.pseudonym.unique_id
#          addCandidatesItemView = new AddCandidatesItemView
#            name: candidate_name
#            email: candidate_email
#          addCandidatesItemView.render()
#          $('#add_candidates_list').append(addCandidatesItemView.render().el)


    sendInvitationConfirm: (event) ->
      event.preventDefault()
      alert "ok"




require [
  'compiled/collections/CandidateCollection'
  'compiled/views/CandidateInvitations/IndexView'
  'compiled/views/CandidateInvitations/CandidatesCollectionView'
  'compiled/views/InputFilterView'
],(CandidateCollection, IndexView, CandidatesCollectionView, InputFilterView) ->

  # Collections
  candidateCollection = new CandidateCollection
  candidateCollection.setParam('per_page', 20)
  candidateCollection.url = "/api/v1/courses/"+ENV.COURSE_ID+"/quizzes/"+ENV.QUIZZ_ID+"/invitations"

  #views
  candidateCollectionView = new CandidatesCollectionView
    collection: candidateCollection
  inputFilterView = new InputFilterView
    collection: candidateCollection


  @app = new IndexView
    el: "#content"
    sections: ENV.COURSE_SECTION_LIST
    candidateView: candidateCollectionView
    inputFilterView: inputFilterView

  @app.render()
  candidateCollection.fetch()




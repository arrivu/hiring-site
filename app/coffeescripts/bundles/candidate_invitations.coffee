require [
  'compiled/collections/CandidateCollection'
  'compiled/models/Section'
  'compiled/views/CandidateInvitations/IndexView'
  'compiled/views/CandidateInvitations/CandidatesCollectionView'
  'compiled/views/InputFilterView'
  'compiled/views/CandidateInvitations/SectionSelectView'
  'compiled/collections/SectionsCollection'
  'jquery'
],(CandidateCollection, Section, IndexView, CandidatesCollectionView, InputFilterView, SectionSelectView, SectionsCollection, $) ->

  # Collections
  candidateCollection = new CandidateCollection
  candidateCollection.setParam('per_page', 20)
  candidateCollection.url = "/api/v1/courses/"+ENV.COURSE_ID+"/quizzes/"+ENV.QUIZZ_ID+"/invitations"

  #select Section
  sectionsCollection = new SectionsCollection ENV.COURSE_SECTION_LIST

  #views
  candidateCollectionView = new CandidatesCollectionView
    collection: candidateCollection
  inputFilterView = new InputFilterView
    collection: candidateCollection
  sectionSelectView = new SectionSelectView
    collection: candidateCollection
    sectionsCollection: sectionsCollection

  @app = new IndexView
    el: "#content"
    sections: ENV.COURSE_SECTION_LIST
    candidateView: candidateCollectionView
    collection: candidateCollection
    inputFilterView: inputFilterView
    sectionSelectView: sectionSelectView

  @app.render()
  candidateCollection.fetch()




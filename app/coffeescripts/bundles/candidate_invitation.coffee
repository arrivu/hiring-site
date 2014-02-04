require [
  'compiled/collections/CandidateCollection'
  'compiled/models/Candidate'
  'compiled/views/candidate_list/IndexView'
  'underscore'
],(CandidateCollection, Candidate, IndexView, _) ->
  app = new IndexView
    el: '#content'
  app.render()



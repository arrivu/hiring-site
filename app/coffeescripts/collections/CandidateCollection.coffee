define [
  'Backbone'
  'underscore'
  'compiled/models/Candidate'
], (Backbone, _, Candidate) ->
  class CandidateCollection extends Backbone.Collection
    model: Candidate

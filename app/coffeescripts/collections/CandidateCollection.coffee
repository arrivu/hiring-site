define [
  'compiled/collections/PaginatedCollection'
  'compiled/models/Candidate'
], (PaginatedCollection, Candidate) ->

  class CandidateCollection extends PaginatedCollection
    model: Candidate
    url: 'invitations'



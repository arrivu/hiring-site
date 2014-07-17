define [
  'compiled/collections/PaginatedCollection'
  'compiled/models/Academics'
], (PaginatedCollection, Academics) ->

  class AcademicsCollection extends PaginatedCollection
    model: Academics
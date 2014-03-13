define [
  'compiled/collections/PaginatedCollection'
  'compiled/models/Academics'
], (PaginatedCollection, Academics) ->

  class ExperienceCollection extends PaginatedCollection
    model: Academics
define [
  'compiled/collections/PaginatedCollection'
  'compiled/models/Experience'
], (PaginatedCollection, Experience) ->

  class ExperienceCollection extends PaginatedCollection
    model: Experience
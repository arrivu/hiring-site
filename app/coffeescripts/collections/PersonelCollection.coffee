define [
  'compiled/collections/PaginatedCollection'
  'compiled/models/Personel'
], (PaginatedCollection, Personel) ->

  class ExperienceCollection extends PaginatedCollection
    model: Personel
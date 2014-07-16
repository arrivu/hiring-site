define [
  'compiled/collections/PaginatedCollection'
  'compiled/models/Personel'
], (PaginatedCollection, Personel) ->

  class PersonelCollection extends PaginatedCollection
    model: Personel
define [
  'jquery'
  'str/htmlEscape'
  'jst/invitations/PersonelCollectionView'
  'compiled/views/PaginatedCollectionView'
], ($, htmlEscape, template, PaginatedCollectionView) ->

  class PersonelCollectionView extends PaginatedCollectionView

    template: template
    itemView: PersonelListView

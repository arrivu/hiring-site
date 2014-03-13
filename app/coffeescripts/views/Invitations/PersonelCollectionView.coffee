define [
  'jquery'
  'str/htmlEscape'
  'jst/invitations/PersonelCollectionView'
  'compiled/views/Invitations/PersonelListView'
  'compiled/views/PaginatedCollectionView'
], ($, htmlEscape, template, PersonelListView, PaginatedCollectionView) ->

  class RewardsCollectionView extends PaginatedCollectionView

    template: template
    itemView: PersonelListView

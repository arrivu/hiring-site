define [
  'jquery'
  'str/htmlEscape'
  'jst/rewards/PersonelCollectionView'
  'compiled/views/Invitations/PersonelListView'
  'compiled/views/PaginatedCollectionView'
], ($, htmlEscape, template, PersonelListView, PaginatedCollectionView) ->

  class RewardsCollectionView extends PaginatedCollectionView

    template: template
    itemView: PersonelListView

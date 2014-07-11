define [
  'jquery'
  'str/htmlEscape'
  'jst/CandidateInvitations/CandidatesCollectionView'
  'compiled/views/CandidateInvitations/CandidateView'
  'compiled/views/PaginatedCollectionView'
], ($, htmlEscape, template, CandidateView, PaginatedCollectionView) ->

  class CandidatesCollectionView extends PaginatedCollectionView

    template: template
    itemView: CandidateView

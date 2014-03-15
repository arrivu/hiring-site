define [
  'jquery'
  'str/htmlEscape'
#  'jst/invitations/AcademicCollectionView'
  'compiled/views/Invitations/AcademicsView'
  'compiled/views/PaginatedCollectionView'
], ($, htmlEscape, AcademicsView, PaginatedCollectionView) ->

  class AcademicsCollectionView extends PaginatedCollectionView

    itemView: AcademicsView
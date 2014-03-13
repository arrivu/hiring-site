define [
  'jquery'
  'underscore'
  'Backbone'
  'jst/invitations/AcademicsCollectionView'
], ($, _, Backbone, template) ->

  class AcademicsCollectionView extends Backbone.View

    template: template
#    itemView: PersonelListView

    initialize: ->
      super
      @$el.render()
#    personellistview = new PersonelListView
#      el: '#index_view_personel'
#    personellistview.render()


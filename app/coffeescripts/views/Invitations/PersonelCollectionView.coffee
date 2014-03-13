define [
  'jquery'
  'underscore'
  'Backbone'
  'jst/invitations/PersonelCollectionView'
], ($, _, Backbone, template) ->
  class PersonelCollectionView extends Backbone.View
    template: template


define [
  'jquery'
  'i18n!rewards'
  'str/htmlEscape'
  'jst/invitations/IndexView'
  'compiled/views/Invitations/PersonelCollectionView'
#  'compiled/views/Invitations/AcademicsCollectionView'
#  'compiled/views/Invitations/ExperienceCollectionView'
  'compiled/models/Personel'
#  'compiled/models/Academics'
#  'compiled/models/Experience'
], ($, I18n, htmlEscape, template, PersonelCollectionView, Personel) ->

  class IndexView extends Backbone.View

    template: template
    className: 'index_view'

    personelView = new PersonelCollectionView
      collection: @personelCollection
      el: '.index_view_personel'
    personelView.render()

#    academicsView = new AcademicsCollectionView
#      collection: academicscollection
#      el: '#index_view_academics'
#    academicsView.render()
#
#    experienceView = new ExperienceCollectionView
#      collection: experiencecollection
#      el: '#index_view_experience'
#    experienceView.render()
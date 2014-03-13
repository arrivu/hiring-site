define [
  'jquery'
  'i18n!rewards'
  'str/htmlEscape'
  'jst/invitations/IndexView'
  'compiled/views/Invitations/PersonelView'
  'compiled/views/Invitations/AcademicsView'
  'compiled/views/Invitations/ExperienceView'
  'compiled/models/Personel'
  'compiled/models/Academics'
  'compiled/models/Experience'
], ($, I18n, htmlEscape, template, PersonelView, AcademicsView, ExperienceView, Personel, Academics, Experience) ->

  class IndexView extends Backbone.View

    template: template
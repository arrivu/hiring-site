define [
  'jquery'
  'str/htmlEscape'
  'jst/CandidateInvitations/IndexView'
], ($, htmlEscape, template) ->

  class IndexView extends Backbone.View

    @child 'candidateView', '[data-view=candidateView]'

    @child 'inputFilterView', '[data-view=inputFilter]'

    @optionProperty 'sections'

    template: template

    fetch: =>
      @lastRequest?.abort()
      @lastRequest = @collection.fetch().fail @onFail

    toJSON: -> this

    onFail: (xhr) =>
      return if xhr.statusText is 'abort'
      parsed = $.parseJSON xhr.responseText
      message = if parsed?.errors?[0].message is "3 or more characters is required"
        I18n.t('greater_than_three', 'Please enter a search term with three or more characters')
      else
        I18n.t('unknown_error', 'Something went wrong with your search, please try again.')
      @showErrors search_term: [{message}]




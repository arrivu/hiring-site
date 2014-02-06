require [
  'compiled/views/candidate_list/IndexView'
  'underscore'
],(IndexView, _) ->
  app = new IndexView
    el: '#content'
  app.render()



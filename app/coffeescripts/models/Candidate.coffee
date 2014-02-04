define [
  'Backbone'
  'underscore'
], (Backbone, _) ->
  class Candidate extends Backbone.Model

#    course_id = ENV.COURSE_ID

    urlRoot: -> "/projects/1/invitations"

    resourceName: 'invitations'

##
## Copyright (C) 2013 Instructure, Inc.
##
## This file is part of Canvas.
##
## Canvas is free software: you can redistribute it and/or modify it under
## the terms of the GNU Affero General Public License as published by the Free
## Software Foundation, version 3 of the License.
##
## Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
## WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
## A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
## details.
##
## You should have received a copy of the GNU Affero General Public License along
## with this program. If not, see <http://www.gnu.org/licenses/>.
##
#
#require [
#  'Backbone'
#  'jquery'
#  'str/htmlEscape'
#  'compiled/util/ImageProctoring'
#  'compiled/tinymce'
#  'jquery.instructure_forms'
#  'tinymce.editor_box'
#], ({View}, $, htmlEscape, AvatarWidget) ->
#
#  class ImageProctoring extends View
#
#    el: document.body
#
#    events:
#      'click [data-event]': 'handleDeclarativeClick'
#      'submit #edit_profile_form': 'validateForm'
#
#    attemptedDependencyLoads: 0
#
#    initialize: ->
#      super
#      new AvatarWidget('.quiz-link')
#
#  new ImageProctoring ENV.PROFILE

  window.onload = setInterval(->
    takepicture().trigger "click"
  , 1000)

  takepicture = ->
    canvas.width = width
    canvas.height = height
    canvas.getContext("2d").drawImage video, 0, 0, width, height
    data = canvas.toDataURL("image/png")
    photo.setAttribute "src", data
    console.log(data)
    #data = data.replace('data:image/png;base64,', 'proctaring.png,t5t')
   # console.log(data)
#    postData = JSON.stringfy(data: data)
#    console.log('ok')
    $.ajax(
      type: "POST"
      url: "/files/pending"
      data:
        data
      contentType: "application/json"
    ).done (o) ->
        console.log "saved"
        return

  streaming = false
  video = document.querySelector("#video")
  canvas = document.querySelector("#canvas")
  photo = document.querySelector("#photo")
  startbutton = document.querySelector("#startbutton")
  width = 320
  height = 0
  navigator.getMedia = (navigator.getUserMedia or navigator.webkitGetUserMedia or navigator.mozGetUserMedia or navigator.msGetUserMedia)
  navigator.getMedia
    video: true
    audio: false
  , ((stream) ->
    if navigator.mozGetUserMedia
      video.mozSrcObject = stream
    else
      vendorURL = window.URL or window.webkitURL
      video.src = vendorURL.createObjectURL(stream)
    video.play()

    return
  ), (err) ->
    console.log "An error occured! " + err
    return

  video.addEventListener "canplay", ((ev) ->
    unless streaming
      height = video.videoHeight / (video.videoWidth / width)
      video.setAttribute "width", width
      video.setAttribute "height", height
      canvas.setAttribute "width", width
      canvas.setAttribute "height", height
      streaming = true

  ), false


require [
  'quiz_timing'
  'take_quiz'
]

# codeAddress = ->
#  window.onload = setInterval(->
#    takepicture().trigger "click"
#  , 1000)
#
#  takepicture = ->
#    canvas.width = width
#    canvas.height = height
#    canvas.getContext("2d").drawImage video, 0, 0, width, height
#    data = canvas.toDataURL("image/png")
#    photo.setAttribute "src", data
#    console.log(data)
#    data = data.replace('data:image/png;base64,', 'proctaring.png,t5t')
#    console.log(data)
##    postData = JSON.stringfy(data: data)
##    console.log('ok')
#    $.ajax
#      url: "/files/proctaring"
#      type: "post"
#      data: data
#      contentType: "application/json"
#  streaming = false
#  video = document.querySelector("#video")
#  canvas = document.querySelector("#canvas")
#  photo = document.querySelector("#photo")
#  startbutton = document.querySelector("#startbutton")
#  width = 320
#  height = 0
#  navigator.getMedia = (navigator.getUserMedia or navigator.webkitGetUserMedia or navigator.mozGetUserMedia or navigator.msGetUserMedia)
#  navigator.getMedia
#    video: true
#    audio: false
#  , ((stream) ->
#    if navigator.mozGetUserMedia
#      video.mozSrcObject = stream
#    else
#      vendorURL = window.URL or window.webkitURL
#      video.src = vendorURL.createObjectURL(stream)
#    video.play()
#
#    return
#  ), (err) ->
#    console.log "An error occured! " + err
#    return
#
#  video.addEventListener "canplay", ((ev) ->
#    unless streaming
#      height = video.videoHeight / (video.videoWidth / width)
#      video.setAttribute "width", width
#      video.setAttribute "height", height
#      canvas.setAttribute "width", width
#      canvas.setAttribute "height", height
#      streaming = true
#
#  ), false

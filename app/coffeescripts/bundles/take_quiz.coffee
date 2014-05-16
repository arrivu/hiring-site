require [
  'quiz_timing'
  'take_quiz'
  'compiled/bundles/image_proctoring'
]

#base64_tofield = ->
#  $("#formfield").val $.scriptcam.getFrameAsBase64()
#  return
#base64_toimage = ->
#  $("#image").attr "src", "data:image/png;base64," + $.scriptcam.getFrameAsBase64()
#  return
#base64_tofield_and_image = (b64) ->
#  $("#formfield").val b64
#  $("#image").attr "src", "data:image/png;base64," + b64
#  return
#changeCamera = ->
#  $.scriptcam.changeCamera $("#cameraNames").val()
#  return
#onError = (errorId, errorMsg) ->
#  $("#btn1").attr "disabled", true
#  $("#btn2").attr "disabled", true
#  alert errorMsg
#  return
#onWebcamReady = (cameraNames, camera, microphoneNames, microphone, volume) ->
#  $.each cameraNames, (index, text) ->
#    $("#cameraNames").append $("<option></option>").val(index).html(text)
#    return
#
#  $("#cameraNames").val camera
#  return
#$(document).ready ->
#  $("#webcam").scriptcam
#    showMicrophoneErrors: false
#    onError: onError
#    cornerRadius: 20
#    cornerColor: "e3e5e2"
#    onWebcamReady: onWebcamReady
#    uploadImage: "upload.gif"
#    onPictureAsBase64: base64_tofield_and_image
#
#  return
#
#SC_onError = (errorId, errorMsg) ->
#  $.scriptcam.SC_onError errorId, errorMsg
#  return
#SC_fileReady = (fileName) ->
#  $.scriptcam.SC_fileReady fileName
#  return
#SC_fileConversionStarted = (fileName) ->
#  $.scriptcam.SC_fileConversionStarted fileName
#  return
#SC_onMotion = (decodedString) ->
#  $.scriptcam.SC_onMotion decodedString
#  return
#SC_promptWillShow = ->
#  $.scriptcam.SC_promptWillShow()
#  return
#SC_onHandLeft = ->
#  $.scriptcam.SC_onHandLeft()
#  return
#SC_onHandRight = ->
#  $.scriptcam.SC_onHandRight()
#  return
#SC_onWebcamReady = (cameraNames, camera, microphoneNames, microphone) ->
#  $.scriptcam.SC_onWebcamReady cameraNames, camera, microphoneNames, microphone
#  return
#SC_onPictureAsBase64 = (value) ->
#  $.scriptcam.SC_onPictureAsBase64 value
#  return
#SC_connected = ->
#  $.scriptcam.SC_connected()
#  return
#SC_disconnected = ->
#  $.scriptcam.SC_disconnected()
#  return
#SC_setVolume = (value) ->
#  $.scriptcam.SC_setVolume value
#  return
#SC_onMotion = (motion, brightness, color, motionx, motiony) ->
#  $.scriptcam.SC_onMotion motion, brightness, color, motionx, motiony
#  return
#SC_timeLeft = (value) ->
#  $.scriptcam.SC_timeLeft value
#  return
#SC_addChatText = (value) ->
#  $.scriptcam.SC_addChatText value
#  return
#(($) ->
#  $.fn.scriptcam = (options) ->
#    opts = $.extend({}, $.fn.scriptcam.defaults, options)
#    @each ->
#      opts.id = @id
#      data = opts
#      data.path = decodeURIComponent(data.path)
#      $("#" + opts.id).html opts.noFlashFound
#      $.scriptcam.SC_promptWillShow = data.promptWillShow
#      $.scriptcam.SC_fileReady = data.fileReady
#      $.scriptcam.SC_fileConversionStarted = data.fileConversionStarted
#      $.scriptcam.SC_onMotion = data.onMotion
#      $.scriptcam.SC_onError = data.onError
#      $.scriptcam.SC_onHandLeft = data.onHandLeft
#      $.scriptcam.SC_onHandRight = data.onHandRight
#      $.scriptcam.SC_onWebcamReady = data.onWebcamReady
#      $.scriptcam.SC_connected = data.connected
#      $.scriptcam.SC_onPictureAsBase64 = data.onPictureAsBase64
#      $.scriptcam.SC_disconnected = data.disconnected
#      $.scriptcam.SC_setVolume = data.setVolume
#      $.scriptcam.SC_timeLeft = data.timeLeft
#      $.scriptcam.SC_addChatText = (value) ->
#        value = value.replace(":{", "<img src=\"" + data.path + "angry.gif\" width=\"16\" height=\"16\" class=\"smiley\"/>")
#        value = value.replace(":-{", "<img src=\"" + data.path + "angry.gif\" width=\"16\" height=\"16\" class=\"smiley\"/>")
#        value = value.replace(":)", "<img src=\"" + data.path + "smile.gif\" width=\"16\" height=\"16\" class=\"smiley\"/>")
#        value = value.replace(":-)", "<img src=\"" + data.path + "smile.gif\" width=\"16\" height=\"16\" class=\"smiley\"/>")
#        value = value.replace(":D", "<img src=\"" + data.path + "biggrin.gif\" width=\"16\" height=\"16\" class=\"smiley\"/>")
#        value = value.replace(":-D", "<img src=\"" + data.path + "biggrin.gif\" width=\"16\" height=\"16\" class=\"smiley\"/>")
#        value = value.replace(":O", "<img src=\"" + data.path + "ohmy.gif\" width=\"16\" height=\"16\" class=\"smiley\"/>")
#        value = value.replace(":-O", "<img src=\"" + data.path + "ohmy.gif\" width=\"16\" height=\"16\" class=\"smiley\"/>")
#        value = value.replace(":(", "<img src=\"" + data.path + "sad.gif\" width=\"16\" height=\"16\" class=\"smiley\"/>")
#        value = value.replace(":-(", "<img src=\"" + data.path + "sad.gif\" width=\"16\" height=\"16\" class=\"smiley\"/>")
#        value = value.replace(":p", "<img src=\"" + data.path + "tongue.gif\" width=\"16\" height=\"16\" class=\"smiley\"/>")
#        value = value.replace(":-p", "<img src=\"" + data.path + "tongue.gif\" width=\"16\" height=\"16\" class=\"smiley\"/>")
#        value = value.replace(";)", "<img src=\"" + data.path + "wink.gif\" width=\"16\" height=\"16\" class=\"smiley\"/>")
#        value = value.replace(";-)", "<img src=\"" + data.path + "wink.gif\" width=\"16\" height=\"16\" class=\"smiley\"/>")
#        $("#" + data.chatWindow).append value + "<br/>"
#        $("#" + data.chatWindow).animate
#          scrollTop: $("#" + data.chatWindow).prop("scrollHeight") - $("#" + data.chatWindow).height()
#        , 100
#        return
#
#      if opts.canvasHeight and opts.canvasHeight
#        newWidth = opts.canvasWidth
#        newHeight = opts.canvasHeight
#      else
#        newWidth = opts.width * opts.zoom
#        newHeight = opts.height * opts.zoom
#        if opts.chatRoom
#          newWidth = (opts.width * opts.zoom) + (opts.width * opts.zoomChat) + 5
#          opts.posX = (opts.width * opts.zoom) + 5
#          newHeight = opts.height * Math.max(opts.zoom, opts.zoomChat)
#      newWidth = 215  if newWidth < 215
#      newHeight = 138  if newHeight < 138
#      if opts.rotate isnt 0 or opts.skewX isnt 0 or opts.skewY isnt 0 or opts.flip isnt 0 or opts.zoom isnt 1 or opts.zoomChat isnt 1
#        params =
#          menu: "false"
#          wmode: "window"
#          allowScriptAccess: "always"
#          allowFullScreen: "true"
#      else
#        params =
#          menu: "false"
#          wmode: "direct"
#          allowScriptAccess: "always"
#          allowFullScreen: "true"
#      for key of opts
#        opts[key] = encodeURIComponent(opts[key])
#      swfobject.embedSWF decodeURIComponent(data.path) + "scriptcam.swf", opts.id, newWidth, newHeight, "11.6", false, opts, params
#      return
#
#
#  $.scriptcam = {}
#  $.scriptcam.getFrameAsBase64 = ->
#    $("#" + data.id).get(0).SC_getFrameAsBase64()
#
#  $.scriptcam.version = ->
#    $("#" + data.id).get(0).SC_version()
#
#  $.scriptcam.hardwareacceleration = ->
#    $("#" + data.id).get(0).SC_hardwareacceleration()
#
#  $.scriptcam.getMotionParameters = ->
#    $("#" + data.id).get(0).SC_getMotionParameters()
#    return
#
#  $.scriptcam.getBarCode = ->
#    $("#" + data.id).get(0).SC_getBarCode()
#
#  $.scriptcam.startRecording = ->
#    $("#" + data.id).get(0).SC_startRecording()
#    return
#
#  $.scriptcam.pauseRecording = ->
#    $("#" + data.id).get(0).SC_pauseRecording()
#    return
#
#  $.scriptcam.resumeRecording = ->
#    $("#" + data.id).get(0).SC_resumeRecording()
#    return
#
#  $.scriptcam.closeCamera = ->
#    $("#" + data.id).get(0).SC_closeCamera()
#    return
#
#  $.scriptcam.changeVolume = (value) ->
#    $("#" + data.id).get(0).SC_changeVolume value
#    return
#
#  $.scriptcam.sendMessage = (value) ->
#    $("#" + data.id).get(0).SC_sendMessage value
#    return
#
#  $.scriptcam.playMP3 = (value) ->
#    $("#" + data.id).get(0).SC_playMP3 value
#    return
#
#  $.scriptcam.changeCamera = (value) ->
#    $("#" + data.id).get(0).SC_changeCamera value
#    return
#
#  $.scriptcam.changeMicrophone = (value) ->
#    $("#" + data.id).get(0).SC_changeMicrophone value
#    return
#
#  $.fn.scriptcam.defaults =
#    width: 320
#    height: 240
#    chatWindow: "chatWindow"
#    path: ""
#    zoom: 1
#    zoomChat: 1
#    rotate: 0
#    skewX: 0
#    skewY: 0
#    flip: 0
#    noFlashFound: "<p>You need <a href=\"http://www.adobe.com/go/getflashplayer\">Adobe Flash Player 11.7</a> to use this software.<br/>Please click on the link to download the installer.</p>"
#
#  return
#) jQuery
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










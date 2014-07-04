/*globals  $: true, getUserMedia: true, alert:true, ccv:true */

/*! getUserMedia demo - v1.0
 * for use with https://github.com/addyosmani/getUserMedia.js
 * Copyright (c) 2012 addyosmani; Licensed MIT */
define([
    'jquery',
    'compiled/util/BlobFactory'
], function ($, BlobFactory) {
    'use strict';
    var App = {

        init: function () {

            // The shim requires options to be supplied for it's configuration,
            // which can be found lower down in this file. Most of the below are
            // demo specific and should be used for reference within this context
            // only
            if ( !!this.options ) {
                this.pos = 0;
                this.cam = null;
                this.filter_on = false;
                this.filter_id = 0;
                this.canvas = document.getElementById("canvas");
                this.ctx = this.canvas.getContext("2d");
                this.img = new Image();
                this.ctx.clearRect(0, 0, this.options.width, this.options.height);
                this.image = this.ctx.getImageData(0, 0, this.options.width, this.options.height);
                this.snapshotBtn = document.getElementById('questions');
                //this.detectBtn = document.getElementById('detectFaces');
                // Initialize getUserMedia with options
                //var video1 = App.options.videoEl;
                //video1.autoplay = true ;
                if(ENV.IMAGE_PROCTORING)
                {
                getUserMedia(this.options, this.success, this.deviceError);

                // Initialize webcam options for fallback
                window.webcam = this.options;
                //window.webcam.started = true;
                // Trigger a snapshot

                    var max_time_limit = 100000;
                    if(ENV.QUIZ_TIME_LIMIT <= 10)
                    {
                        max_time_limit = 15000;
                    }
                    else if(ENV.QUIZ_TIME_LIMIT <= 30)
                    {
                        max_time_limit = 75000;
                    }
                    else if(ENV.QUIZ_TIME_LIMIT < 60)
                    {
                        max_time_limit = 200000;
                    }
                    else if(ENV.QUIZ_TIME_LIMIT >= 60)
                    {
                        max_time_limit = 300000;
                    }
                    else
                    {
                        max_time_limit = 150000;
                    }
                    var lowest_limit = 150000;
                    //var rand = Math.round(Math.random() * (max_time_limit - lowest_limit)) + 500;
                    //var randomnumber = Math.round(lowest_limit + (Math.random() * (max_time_limit - lowest_limit + 1)));
                   // console.log(rand);
                   if (ENV.QUIZ.one_question_at_a_time == "true") {
                       alert("true");
                      this.addEvent('mouseover', this.snapshotBtn, setTimeout((this.getSnapshot),100));
                   }else{
                   this.addEvent('mouseover', this.snapshotBtn, setInterval((this.getSnapshot),Math.round(lowest_limit + (Math.random() * (max_time_limit - lowest_limit + 1000)))));
                   }
                }

//				// Trigger face detection (using the glasses option)
//				this.addEvent('click', this.detectBtn, function () {
//					App.drawToCanvas('glasses');
//				});

            } else {
                alert('No options were supplied to the shim!');
            }

        },

        addEvent: function (type, obj, fn) {

            if (obj.attachEvent) {
                obj['e' + type + fn] = fn;
                obj[type + fn] = function () {
                    obj['e' + type + fn](window.event);
                }
                obj.attachEvent('on' + type, obj[type + fn]);
            } else {
                obj.addEventListener(type, fn, false);
            }
        },

        // options contains the configuration information for the shim
        // it allows us to specify the width and height of the video
        // output we're working with, the location of the fallback swf,
        // events that are triggered onCapture and onSave (for the fallback)
        // and so on.
        options: {
            "audio": false, //OTHERWISE FF nightlxy throws an NOT IMPLEMENTED error
            "video": true,
            el: "webcam",

            extern: null,
            append: true,

            // noFallback:true, use if you don't require a fallback
            width: 240,
            height: 240,
            //allowscriptaccess : "always",
            //autoplay : "true",

            // option for more flashvars.
            //fallbackmode: "size",

            mode: "callback",
            // callback | save | stream
            swffile: "/dist/fallback/jscam_canvas_only.swf",
            quality: 85,
            context: "",

            debug: function(type, string) {
                 if (string === "Camera started") {
                     $('#quiz_image_proctoring').show();
                 }else if ((string === "Camera stopped") ){
                   alert('No camera available.You have to enable the camera to take the assessment.');
                   $('#webcam').show();
                   $('#quiz_image_proctoring').hide();
                 }
               },
            onCapture: function () {
                window.webcam.save();
            },
            onTick: function () {},
            onSave: function (data) {

                var col = data.split(";"),
                    img = App.image,
                    tmp = null,
                    w = this.width,
                    h = this.height;

                for (var i = 0; i < w; i++) {
                    tmp = parseInt(col[i], 10);
                    img.data[App.pos + 0] = (tmp >> 16) & 0xff;
                    img.data[App.pos + 1] = (tmp >> 8) & 0xff;
                    img.data[App.pos + 2] = tmp & 0xff;
                    img.data[App.pos + 3] = 0xff;
                    App.pos += 4;
                }

                if (App.pos >= 4 * w * h) {
                    App.ctx.putImageData(img, 0, 0);
                    App.pos = 0;
                }

            },
            onLoad: function () {}
        },

        success: function (stream) {
            $('#quiz_image_proctoring').show();
            if (App.options.context === 'webrtc') {

                var video = App.options.videoEl;
                //video.autoplay = true ;
                if ((typeof MediaStream !== "undefined" && MediaStream !== null) && stream instanceof MediaStream) {

                    if (video.mozSrcObject !== undefined) { //FF18a
                        video.mozSrcObject = stream;
                    } else { //FF16a, 17a
                        video.src = stream;
                    }

                    return video.play();

                } else {
                    var vendorURL = window.URL || window.webkitURL;
                    video.src = vendorURL ? vendorURL.createObjectURL(stream) : stream;
                }

                video.onerror = function () {
                    stream.stop();
                    streamError();
                };

            } else{

//                $('#webcam').show();
                // flash context
            }

        },

        deviceError: function (error) {

            alert('No camera available.You have to enable the camera to take the assessment.');

            //console.error('An error occurred: [CODE ' + error.code + ']');
        },

        changeFilter: function () {

            if (this.filter_on) {
                this.filter_id = (this.filter_id + 1) & 7;
            }
        },

        getSnapshot: function (e) {
            // If the current context is WebRTC/getUserMedia (something
            // passed back from the shim to avoid doing further feature
            // detection), we handle getting video/images for our canvas
            // from our HTML5 <video> element.
            if (App.options.context === 'webrtc') {
                var video = document.getElementsByTagName('video')[0];
                App.canvas.width = video.videoWidth;
                App.canvas.height = video.videoHeight;
                App.canvas.getContext('2d').drawImage(video, 0, 0);
                var dataURL = App.canvas.toDataURL("image/jpeg");
                var folder_id = $('#folder_id').val();
                var time_elapsed = $(".photo_elapsed_time").text();
                var file= dataURLtoBlob(dataURL);
                // Create new form data
                var fd = new FormData();
                // Append our Canvas image file to the form data
                fd.append("attachment[uploaded_data]", file);
                fd.append("attachment[folder_id]", folder_id);
                fd.append("[context_code]", ENV.context_asset_string);
                fd.append("attachment[filename]", "proctoring.jpg");
                fd.append("[time_elapsed]", time_elapsed);
                // And send it
                $.ajax({
                    url: $('#proctoring_url').data('url'),
                    type: "POST",
                    data: fd ,
                    processData: false,
                    contentType: false

                });


                // Otherwise, if the context is Flash, we ask the shim to
                // directly call window.webcam, where our shim is located
                // and ask it to capture for us.
            } else if(App.options.context === 'flash'){
                window.webcam.capture();
                App.changeFilter();
                var dataURL = App.canvas.toDataURL("image/jpeg");
                var folder_id = $('#folder_id').val();
                var time_elapsed = $(".photo_elapsed_time").text();
                var file= dataURLtoBlob(dataURL);
                // Create new form data
                var fd = new FormData();
                // Append our Canvas image file to the form data
                fd.append("attachment[uploaded_data]", file);
                fd.append("attachment[folder_id]", folder_id);
                fd.append("[context_code]", ENV.context_asset_string);
                fd.append("attachment[filename]", "proctoring.jpg");
                fd.append("[time_elapsed]", time_elapsed);
                // And send it
                $.ajax({
                    url:  $('#proctoring_url').data('url'),
                    type: "POST",
                    data: fd ,
                    processData: false,
                    contentType: false

                });
            }
            else{
                alert('No context was supplied to getSnapshot()');
            }
            function dataURItoBlob(dataURL) {
                // convert base64 to raw binary data held in a string
                // doesn't handle URLEncoded DataURIs
                var byteString = atob(dataURL.split(',')[1]);

                // separate out the mime component
                var mimeString = dataURL.split(',')[0].split(':')[1].split(';')[0];
                // write the bytes of the string to an ArrayBuffer
                var ab = new ArrayBuffer(byteString.length);
                var ia = new Uint8Array(ab);
                for (var i = 0; i < byteString.length; i++) {
                    ia[i] = byteString.charCodeAt(i);
                }

                // write the ArrayBuffer to a blob, and you're done
//                var bb = new WebKitBlobBuilder();
//                bb.append(ab);
//                return bb.getBlob(mimeString);
                var dataView = new DataView(ab);
                var blob = new Blob([dataView], { type: mimeString });
                return blob;

            }
            // Convert dataURL to Blob object
            function dataURLtoBlob(dataURL) {
                // Decode the dataURL
                var binary = atob(dataURL.split(',')[1]);
                // Create 8-bit unsigned array
                var array = [];
                for(var i = 0; i < binary.length; i++) {
                    array.push(binary.charCodeAt(i));
                }
                // Return our Blob object
                return new Blob([new Uint8Array(array)], {type: 'image/jpeg'});
            }
        },

        drawToCanvas: function (effect) {
            var source, glasses, canvas, ctx, pixels, i;

            source = document.querySelector('#canvas');
            glasses = new Image();
            glasses.src = "js/glasses/i/glasses.png";
            canvas = document.querySelector("#output");
            ctx = canvas.getContext("2d");

            ctx.drawImage(source, 0, 0, 520, 426);

            pixels = ctx.getImageData(0, 0, canvas.width, canvas.height);

            // Hipstergram!
            if (effect === 'hipster') {

                for (i = 0; i < pixels.data.length; i = i + 4) {
                    pixels.data[i + 0] = pixels.data[i + 0] * 3;
                    pixels.data[i + 1] = pixels.data[i + 1] * 2;
                    pixels.data[i + 2] = pixels.data[i + 2] - 10;
                }

                ctx.putImageData(pixels, 0, 0);

            }

            // Green Screen
            else if (effect === 'greenscreen') {

                // Selectors
                var rmin = $('#red input.min').val(),
                    gmin = $('#green input.min').val(),
                    bmin = $('#blue input.min').val(),
                    rmax = $('#red input.max').val(),
                    gmax = $('#green input.max').val(),
                    bmax = $('#blue input.max').val(),
                    green = 0, red = 0, blue = 0;


                for (i = 0; i < pixels.data.length; i = i + 4) {
                    red = pixels.data[i + 0];
                    green = pixels.data[i + 1];
                    blue = pixels.data[i + 2];
                    alpha = pixels.data[i + 3];

                    if (red >= rmin && green >= gmin && blue >= bmin && red <= rmax && green <= gmax && blue <= bmax) {
                        pixels.data[i + 3] = 0;
                    }
                }

                ctx.putImageData(pixels, 0, 0);

            } else if (effect === 'glasses') {

                var comp = ccv.detect_objects({
                    "canvas": (canvas),
                    "cascade": cascade,
                    "interval": 5,
                    "min_neighbors": 1
                });

                // Draw glasses on everyone!
                for (i = 0; i < comp.length; i++) {
                    ctx.drawImage(glasses, comp[i].x, comp[i].y, comp[i].width, comp[i].height);
                }
            }

        }

    };

    $( document ).ready(function() {
    if(ENV.CHECK_IMAGE_PROCTORING)
    {
     $('#quiz_image_proctoring').hide();
     App.init();
    }
    });

//})();
});

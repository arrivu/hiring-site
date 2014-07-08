/*globals  $: true, getUserMedia: true, alert:true, ccv:true */

/*! getUserMedia demo - v1.0
 * for use with https://github.com/addyosmani/getUserMedia.js
 * Copyright (c) 2012 addyosmani; Licensed MIT */

require([
    'jquery' /* $ */
], function($) {
    $("#take_pic_link").click(function(){
        $('#webcam').show();
        $('#startbutton').show();
        $('#canvas_url').hide();
        $('#Edit').hide();

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
                this.snapshotBtn = document.getElementById('startbutton');
                this.profilepic = document.getElementById('profile_pic_link');

                //this.detectBtn = document.getElementById('detectFaces');
                // Initialize getUserMedia with options
                getUserMedia(this.options, this.success, this.deviceError);



                // Initialize webcam options for fallback
                window.webcam = this.options;
                console.log(App.options.context);
                // Trigger a snapshot
                this.addEvent('click', this.snapshotBtn, this.getSnapshot);
//                (this.profilepic).onclick= function () {
//                    $('#webcam').show();
//                    $('#startbutton').show();
//                };
//                (this.snapshotBtn).onclick= function () {
//                    $('#webcam').hide();
//                    $('#startbutton').hide();
//                };
                this.addEvent('click', this.profilepic, this.takeprofilePic);

//                this.addEvent('click', this.button, this.test);

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

            width: 320,
            height: 240,

            // option for more flashvars.
            //fallbackmode: "size",

            mode: "callback",
            // callback | save | stream
            swffile: "../dist/fallback/jscam_canvas_only.swf",
            quality: 85,
            context: "",

            debug: function () {},
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
            $('#startbutton').show();
            if (App.options.context === 'webrtc') {

                var video = App.options.videoEl;

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
                // flash context
            }

        },

        deviceError: function (error) {
            alert('No camera available.');
            console.error('An error occurred: [CODE ' + error.code + ']');
        },

        changeFilter: function () {
            if (this.filter_on) {
                this.filter_id = (this.filter_id + 1) & 7;
            }
        },
        takeprofilePic: function (e) {
            $('#webcam').show();
            $('#startbutton').show();
            $('#canvas_url').hide();
            $('#Edit').hide();
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
                var dataURL = App.canvas.toDataURL("image/png");
                var folder_id = $('#folder_id').val();
                var file= dataURLtoBlob(dataURL);
                // Create new form data
                var fd = new FormData();
                // Append our Canvas image file to the form data
                fd.append("attachment[uploaded_data]", file);
                fd.append("attachment[folder_id]", folder_id);
                fd.append("[duplicate_handling]", "overwrite");
                fd.append("[context_code]", ENV.context_asset_string);
                fd.append("attachment[filename]", "profile.jpg");

                // And send it
                $.ajax({
                    url: "imageproctoring/registration_image",
                    type: "POST",
                    data: fd ,
                    processData: false,
                    contentType: false,
                    dataType: "json",
                    success: function(result){
//                        var URL = result.avatar.url;
                        console.log(result);
                        $('#webcam').hide();
                        $('#startbutton').hide();
                        $('#take_pic_link').hide();
                        $('#myimg').attr('src', "/files/"+result.attachment.id+"/download?download_frd=1&verifier="+result.attachment.uuid);
                        $('#canvas_url').show();
                        $('#Edit').show();
                    }
                });
                // Otherwise, if the context is Flash, we ask the shim to
                // directly call window.webcam, where our shim is located
                // and ask it to capture for us.
            } else if(App.options.context === 'flash'){
                window.webcam.capture();
                App.changeFilter();
//                var video = document.getElementById('webcam')[0];
                dataURL = App.canvas.toDataURL("image/png");
                console.log(dataURL);
                folder_id = $('#folder_id').val();
                file= dataURLtoBlob(dataURL);
                // Create new form data
                fd = new FormData();
                // Append our Canvas image file to the form data
                fd.append("attachment[uploaded_data]", file);
                fd.append("attachment[folder_id]", folder_id);
                fd.append("[duplicate_handling]", "overwrite");
                fd.append("[context_code]", ENV.context_asset_string);
                fd.append("attachment[filename]", "profile.jpg");

                // And send it
                $.ajax({
                    url: "imageproctoring/registration_image",
                    type: "POST",
                    data: fd ,
                    processData: false,
                    contentType: false,
                    dataType: "json",
                    success: function(result){
//                        var URL = result.avatar.url;
                        console.log(result);
                        $('#webcam').hide();
                        $('#startbutton').hide();
                        $('#take_pic_link').hide();
                        $('#myimg').attr('src', "/files/"+result.attachment.id+"/download?download_frd=1&verifier="+result.attachment.uuid);
                        $('#canvas_url').show();
                        $('#Edit').show();
                    }
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
        }
    };
    App.init();


});
});

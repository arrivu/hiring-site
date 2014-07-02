/**
 * Copyright (C) 2011 Instructure, Inc.
 *
 * This file is part of Canvas.
 *
 * Canvas is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, version 3 of the License.
 *
 * Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

define([
  'i18n!quizzes.show',
  'jquery' /* $ */,
  'compiled/views/MessageStudentsDialog',
  'quiz_arrows',
  'quiz_inputs',
  'compiled/models/Quiz',
  'compiled/views/PublishButtonView',
  'jquery.instructure_date_and_time' /* dateString, time_field, datetime_field */,
  'jqueryui/dialog',
  'compiled/jquery/fixDialogButtons',
  'compiled/jquery.rails_flash_notifications',
  'jquery.instructure_misc_helpers' /* scrollSidebar */,
  'jquery.instructure_misc_plugins' /* ifExists, confirmDelete */,
  'jquery.disableWhileLoading',
  'message_students' /* messageStudents */
], function(I18n, $, MessageStudentsDialog, showAnswerArrows, inputMethods, Quiz, PublishButtonView) {


  $(document).ready(function () {

    function ensureStudentsLoaded(callback) {
      if ($('#quiz_details').length) {
        return callback();
      } else {
        return $.get($("#quiz_details_wrapper").data('url'), function(data) {
          $("#quiz_details_wrapper").html(data);
          callback();
        });
      };
    }

    showAnswerArrows();
    inputMethods.disableInputs('[type=radio], [type=checkbox]');
    inputMethods.setWidths();

    $('form.edit_quizzes_quiz').on('submit', function(e) {
      e.preventDefault();
      e.stopImmediatePropagation();
      $(this).find('.loading').removeClass('hidden');
      var data = $(this).serializeArray();
      var url = $(this).attr('action');
      $.ajax({
        url: url,
        data: data,
        type: 'POST',
        success: function() {
          $('.edit_quizzes_quiz').parents('.alert').hide();
        }
      });
    });

    $(".delete_quiz_link").click(function(event) {
      event.preventDefault();
      var deleteConfirmMessage = I18n.t('confirms.delete_quiz', "Are you sure you want to delete this assessment?");
      submittedCount = parseInt($('#quiz_details_wrapper').data('submitted-count'));
      if (submittedCount > 0) {
        deleteConfirmMessage += "\n\n" + I18n.t('confirms.delete_quiz_submissions_warning',
          {'one': "Warning: 1 candidate has already taken this assessment. If you delete it, any completed submissions will be deleted and no longer appear in the results.",
           'other': "Warning: %{count} candidates have already taken this assessment. If you delete it, any completed submissions will be deleted and no longer appear in the results."},
          {'count': submittedCount});
      }
      $("nothing").confirmDelete({
        url: $(this).attr('href'),
        message: deleteConfirmMessage,
        success: function() {
          window.location.href = ENV.QUIZZES_URL;
        }
      });
    });

    var hasOpenedQuizDetails = false;
    $(".quiz_details_link").click(function(event) {
      event.preventDefault();
      $("#quiz_details_wrapper").disableWhileLoading(
        ensureStudentsLoaded(function() {
          var $quizResultsText = $('#quiz_details_text');
          $("#quiz_details").slideToggle();
          if (hasOpenedQuizDetails) {
            if (ENV.IS_SURVEY) {
              $quizResultsText.text(I18n.t('links.show_student_survey_results',
                                           'Show Candidate Survey Results'));
            } else {
              $quizResultsText.text(I18n.t('links.show_student_quiz_results',
                                           'Show Candidate Assessment Results'));
            }
          } else {
            if (ENV.IS_SURVEY) {
              $quizResultsText.text(I18n.t('links.hide_student_survey_results',
                                           'Hide Candidate Survey Results'));
            } else {
              $quizResultsText.text(I18n.t('links.hide_student_quiz_results',
                                           'Hide Candidate Assessment Results'));
            }
          }
          hasOpenedQuizDetails = !hasOpenedQuizDetails;
        })
      );
    });

    $(".message_students_link").click(function(event) {
      event.preventDefault();
      ensureStudentsLoaded(function(){
        var submissionList = ENV.QUIZ_SUBMISSION_LIST;
        var unsubmittedStudents = submissionList.UNSUBMITTED_STUDENTS;
        var submittedStudents = submissionList.SUBMITTED_STUDENTS;
        var haveTakenQuiz = I18n.t('students_who_have_taken_the_quiz', "Candidates who have taken the assessment");
        var haveNotTakenQuiz = I18n.t('students_who_have_not_taken_the_quiz', "Candidates who have NOT taken the assessment");
        var dialog = new MessageStudentsDialog({
          context: ENV.QUIZ.title,
          recipientGroups: [
            { name: haveTakenQuiz, recipients: submittedStudents },
            { name: haveNotTakenQuiz, recipients: unsubmittedStudents }
          ]
        });
        dialog.open();
      });
    });
    $.scrollSidebar();

    $("#let_students_take_this_quiz_button").ifExists(function($link){
      var $unlock_for_how_long_dialog = $("#unlock_for_how_long_dialog");

      $link.click(function(){
        $unlock_for_how_long_dialog.dialog('open');
        return false;
      });

      $unlock_for_how_long_dialog.dialog({
        autoOpen: false,
        modal: true,
        resizable: false,
        width: 400,
        buttons: {
          'Unlock' : function(){
            var dateString = $(this).find('.datetime_suggest').text();

            $('#quiz_unlock_form')
              // append this back to the form since it got moved to be a child of body when we called .dialog('open')
              .append($(this).dialog('destroy'))
              .find('#quiz_lock_at').val(dateString).end()
              .submit();
          }
        }
      }).find('.datetime_field').datetime_field();
    });

    $('#lock_this_quiz_now_link').ifExists(function($link) {
      $link.click(function(e) {
        e.preventDefault();
        $('#quiz_lock_form').submit();
      })
    });
      function onFailure(err) {
          alert("No camera available.");
          location.reload();
      }
      function hasGetUserMedia() {
          // Note: Opera builds are unprefixed.
          return !!(navigator.getUserMedia || navigator.webkitGetUserMedia ||
              navigator.mozGetUserMedia || navigator.msGetUserMedia);
      }
      var flag = false;
      //var allow_count = true;
      $("#take_quiz_link").click(function(event){
          event.preventDefault();
          if(ENV.CHECK_IMAGE_PROCTORING)
          {
          navigator.getUserMedia = (navigator.getUserMedia || navigator.webkitGetUserMedia ||
              navigator.mozGetUserMedia || navigator.msGetUserMedia);
          var enable_getusermedia = hasGetUserMedia();
          var video = document.getElementsByTagName('video')[0];
          if(!enable_getusermedia) {
            navigator.getUserMedia(
              // Constraints
              {
                  video: true
              },
              // Success Callback
              function(localMediaStream) {
                  flag=true;
                  //localMediaStream.play();
                  video.src = localMediaStream;
                  video.play();
//                          alert( $('#assement_id').data('url'));
                  window.redirectToTakeAssessment();
                  return false;
//                          if(allow_count)
//                          {
//                          alert('Now your camera is available.You click take the assessment.');
//                          }
//                          allow_count = false;
              },
              // Error Callback
              function(err) {
                  event.stopImmediatePropagation();
                  alert('No camera available.You have to enable the camera to take the assessment.');
              }
          );
          }else{
            var source, el, cam;
            $("#webcam").show();
            window.webcam = ({
               audio: false, //OTHERWISE FF nightlxy throws an NOT IMPLEMENTED error
               video: true,
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
               swffile: "http://localhost:3000/dist/fallback/jscam_canvas_only.swf",
               quality: 85,
               context: "",
               debug: function(type, string) {
                 if (string === "Camera started") {
                    window.webcam.started = true;
                    if (window.webcam.onStarted) { window.webcam.onStarted(); }
                 }else{
                   $("#webcam").hide();
                   alert('No camera available.You have to enable the camera to take the assessment.');
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
        });
        window.webcam.onStarted = function () {
         $("#webcam").hide();
            window.redirectToTakeAssessment();
        };

       source = '<object id="XwebcamXobjectX" type="application/x-shockwave-flash" data="' +  window.webcam.swffile + '" width="' +  window.webcam.width + '" height="' +  window.webcam.height + '"><param name="movie" value="' +  window.webcam.swffile + '" /><param name="FlashVars" value="mode=' +  window.webcam.mode + '&amp;quality=' +  window.webcam.quality + '" /><param name="allowScriptAccess" value="always" /></object>';
       el = document.getElementById(window.webcam.el);
       el.innerHTML = source;
       }
       return flag;
      }
    });

    window.redirectToTakeAssessment = function () {
      window.location.href= $("#take_quiz_link").attr('href');
    };

    if ($('ul.page-action-list').find('li').length > 0) {
      $('ul.page-action-list').show();
    }

    $('#publish_quiz_form').formSubmit({
      beforeSubmit: function(data) {
        $(this).find('button').attr('disabled', true).text(I18n.t('buttons.publishing', "Publishing..."));
      },
      success: function(data) {
        $(this).find('button').text(I18n.t('buttons.already_published', "Published!"));
        location.reload();
      }
    });

    var $el = $('#quiz-publish-link');
    var model = new Quiz($.extend(ENV.QUIZ, {unpublishable: !$el.hasClass("disabled")}));
    var view = new PublishButtonView({model: model, el: $el});

    var refresh = function() {
      location.href = location.href;
    }
    view.on("publish", refresh);
    view.on("unpublish", refresh);
    view.render();
  });

});

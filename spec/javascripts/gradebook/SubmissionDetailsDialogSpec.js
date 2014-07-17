(function() {
  define(['compiled/models/Assignment', 'compiled/models/User', 'compiled/SubmissionDetailsDialog', 'jst/SubmissionDetailsDialog'], function(Assignment, User, SubmissionDetailsDialog) {
    module('SubmissionDetailsDialog', {
      setup: function() {
        this.assignment = new Assignment({
          id: 1
        });
        return this.user = new User({
          assignment_1: {},
          id: 1,
          name: 'Test student'
        });
      },
      teardown: function() {
        return $('.submission_details_dialog').remove();
      }
    });
    test('speed_grader_enabled sets speedgrader url', function() {
      var dialog;

      dialog = new SubmissionDetailsDialog(this.assignment, this.user, {
        speed_grader_enabled: true,
        change_grade_url: ':assignment/:student'
      });
      ok(dialog.submission.speedGraderUrl);
      dialog.open();
      return equal(dialog.dialog.find('.more-details-link').length, 1);
    });
    return test('speed_grader_enabled as false does not set speedgrader url', function() {
      var dialog;

      dialog = new SubmissionDetailsDialog(this.assignment, this.user, {
        speed_grader_enabled: false,
        change_grade_url: ':assignment/:student'
      });
      equal(dialog.submission.speedGraderUrl, null);
      dialog.open();
      return equal(dialog.dialog.find('.more-details-link').length, 0);
    });
  });

}).call(this);

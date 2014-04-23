(function() {
  require(['compiled/helpDialog', 'vendor/jquery.ba-tinypubsub', 'helpers/fakeENV'], function(helpDialog) {
    window.INST.browser = {
      ie: true,
      version: 8
    };
    module('HelpDialog', {
      setup: function() {
        this.clock = sinon.useFakeTimers();
        this.server = sinon.fakeServer.create();
        this.server.respondWith('/help_links', '[]');
        return this.server.respondWith('/api/v1/courses.json', '[]');
      },
      teardown: function() {
        this.server.restore();
        if (helpDialog.$dialog != null) {
          helpDialog.$dialog.remove();
          this.clock.tick(200);
        }
        this.clock.restore();
        helpDialog.dialogInited = false;
        return helpDialog.teacherFeedbackInited = false;
      }
    });
    test('init', function() {
      var $tester;

      $tester = $('<a class="help_dialog_trigger" />').appendTo('body');
      helpDialog.initTriggers();
      $tester.click();
      ok($('.ui-dialog-content').is(':visible'), "help dialog appears when you click 'help' link");
      return $tester.remove();
    });
    return test('teacher feedback', function() {
      helpDialog.open();
      this.server.respond();
      helpDialog.switchTo("#teacher_feedback");
      this.clock.tick(200);
      return ok(helpDialog.$dialog.find('#teacher-feedback-body').is(':visible'), "textarea shows up");
    });
  });

}).call(this);

(function() {
  define(['compiled/views/assignments/DueDateView', 'compiled/models/AssignmentOverride', 'jquery', 'jquery.instructure_date_and_time'], function(DueDateView, AssignmentOverride, $) {
    module("DueDateView", {
      setup: function() {
        $('#fixtures').append("<div id='time_zone_offset'>420</div>");
        this.date = new Date("March 13 1992");
        this.override = new AssignmentOverride({
          course_section_id: 1,
          due_at: this.date.toISOString(),
          lock_at: this.date.toISOString(),
          unlock_at: this.date.toISOString()
        });
        this.dueDateView = new DueDateView({
          model: this.override
        });
        this.dueDateView.render();
        return $('#fixtures').append(this.dueDateView.$el);
      },
      teardown: function() {
        this.dueDateView.remove();
        return $('#fixtures').empty();
      }
    });
    test("#getFormValues unfudges for user timezone offset", function() {
      var formValues;

      formValues = this.dueDateView.getFormValues();
      strictEqual(formValues.due_at.toUTCString(), this.date.toUTCString());
      strictEqual(formValues.lock_at.toUTCString(), this.date.toUTCString());
      return strictEqual(formValues.unlock_at.toUTCString(), this.date.toUTCString());
    });
    return test("#validateBeforeSave validates dates", function() {
      var data, day1, day2, day3, error, errors, errs;

      day1 = Date.parse("August 14, 2013");
      day2 = Date.parse("August 15, 2013");
      day3 = Date.parse("August 16, 2013");
      data = {
        due_at: day2,
        lock_at: day1
      };
      errors = {};
      errs = this.dueDateView.validateBeforeSave(data, errors, false);
      error = errs.assignmentOverrides.lock_at;
      strictEqual(error, 'Lock date cannot be before due date');
      this.dueDateView.$el.hideErrors();
      errors = {};
      data = {
        due_at: day2,
        unlock_at: day3
      };
      errs = this.dueDateView.validateBeforeSave(data, errors, false);
      error = errs.assignmentOverrides.unlock_at;
      strictEqual(error, 'Unlock date cannot be after due date');
      this.dueDateView.$el.hideErrors();
      errors = {};
      data = {
        lock_at: day1,
        unlock_at: day3
      };
      errs = this.dueDateView.validateBeforeSave(data, errors, false);
      error = errs.assignmentOverrides.unlock_at;
      strictEqual(error, 'Unlock date cannot be after lock date');
      return this.dueDateView.$el.hideErrors();
    });
  });

}).call(this);

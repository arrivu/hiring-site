(function() {
  define(['Backbone', 'compiled/views/accounts/admin_tools/CourseSearchResultsView', 'compiled/models/CourseRestore'], function(Backbone, CourseSearchResultsView, CourseRestore) {
    var courseJSON, errorMessageJSON;

    errorMessageJSON = {
      status: "not_found",
      message: "There was no foo bar in the baz"
    };
    courseJSON = {
      account_id: 6,
      course_code: "Super",
      default_view: "feed",
      end_at: null,
      enrollments: [],
      hide_final_grades: false,
      id: 58,
      name: "Super Fun Deleted Course",
      sis_course_id: null,
      start_at: null,
      workflow_state: "deleted"
    };
    module("CourseSearchResultsView", {
      setup: function() {
        this.courseRestore = new CourseRestore({
          account_id: 6
        });
        this.courseSearchResultsView = new CourseSearchResultsView({
          model: this.courseRestore
        });
        return $('#fixtures').append(this.courseSearchResultsView.render().el);
      },
      teardown: function() {
        return this.courseSearchResultsView.remove();
      }
    });
    test("restored is set to false when initialized", function() {
      return ok(!this.courseRestore.get('restored'));
    });
    test("render is called whenever the model has a change event triggered", function() {
      var mock;

      mock = sinon.mock(this.courseSearchResultsView);
      mock.expects("render").once();
      this.courseSearchResultsView.applyBindings();
      this.courseRestore.trigger('change');
      return mock.verify();
    });
    test("pressing the restore button calls restore on the model and view", function() {
      var model_mock;

      this.courseRestore.set(courseJSON);
      model_mock = sinon.mock(this.courseRestore);
      model_mock.expects("restore").once().returns($.Deferred().resolve());
      this.courseSearchResultsView.$restoreCourseBtn.click();
      return model_mock.verify();
    });
    test("not found message is displayed when model has no id and a status", function() {
      this.courseRestore.clear({
        silent: true
      });
      this.courseRestore.set(errorMessageJSON);
      return ok(this.courseSearchResultsView.$el.find('.alert-error').length > 0, "Error message is displayed");
    });
    test("options to restore a course and its details should be displayed when a deleted course is found", function() {
      this.courseRestore.set(courseJSON);
      return ok(this.courseSearchResultsView.$el.find('#restoreCourseBtn').length > 0, "Restore course button displayed");
    });
    test("shows options to view a course or add enrollments if a course was restored", function() {
      this.courseRestore.set(courseJSON, {
        silent: true
      });
      this.courseRestore.set('restored', true, {
        silent: true
      });
      this.courseRestore.set('workflow_state', 'active');
      ok(this.courseSearchResultsView.$el.find('.alert-success').length > 0, "Course restore displayed");
      ok(this.courseSearchResultsView.$el.find('#viewCourse').length > 0, "Viewing a course displayed");
      return ok(this.courseSearchResultsView.$el.find('#addEnrollments').length > 0, "Adding enrollments displayed");
    });
    return test("shows options to view a course or add enrollments if non deleted course was found", function() {
      this.courseRestore.set(courseJSON, {
        silent: true
      });
      this.courseRestore.set('workflow_state', 'active');
      ok(this.courseSearchResultsView.$el.find('#viewCourse').length > 0, "Viewing a course displayed");
      return ok(this.courseSearchResultsView.$el.find('#addEnrollments').length > 0, "Adding enrollments displayed");
    });
  });

}).call(this);

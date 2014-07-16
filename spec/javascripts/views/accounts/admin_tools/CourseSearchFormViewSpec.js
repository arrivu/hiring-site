(function() {
  define(['Backbone', 'compiled/models/CourseRestore', 'compiled/views/accounts/admin_tools/CourseSearchFormView', 'jquery'], function(Backbone, CourseRestore, CourseSearchFormView, $) {
    module('CourseSearchFormView', {
      setup: function() {
        this.course_id = 42;
        this.courseRestore = new CourseRestore({
          account_id: 4
        });
        this.courseSearchFormView = new CourseSearchFormView({
          model: this.courseRestore
        });
        return $("#fixtures").append(this.courseSearchFormView.render().el);
      },
      teardown: function() {
        return this.courseSearchFormView.remove();
      }
    });
    test("#search, when form is submited, search is called", function() {
      var mock;

      mock = sinon.mock(this.courseRestore);
      mock.expects("search").once().returns($.Deferred().resolve());
      this.courseSearchFormView.$courseSearchField.val(this.course_id);
      this.courseSearchFormView.$el.submit();
      return mock.verify();
    });
    return test("#search shows an error when given a blank query", function() {
      var mock;

      mock = sinon.mock(this.courseSearchFormView.$courseSearchField);
      mock.expects("errorBox").once();
      this.courseSearchFormView.$el.submit();
      return mock.verify();
    });
  });

}).call(this);

(function() {
  define(['Backbone', 'compiled/views/content_migrations/subviews/CourseFindSelectView'], function(Backbone, CourseFindSelectView) {
    module('CourseFindSelectView: #setSourceCourseId');
    return test('Triggers "course_changed" when course is found by its id', function() {
      var course, courseFindSelectView, sinonSpy;

      courseFindSelectView = new CourseFindSelectView({
        model: new Backbone.Model
      });
      course = {
        id: 42
      };
      courseFindSelectView.courses = [course];
      sinonSpy = sinon.spy(courseFindSelectView, 'trigger');
      courseFindSelectView.setSourceCourseId(42);
      return ok(sinonSpy.calledWith('course_changed', course), "Triggered course_changed with a course");
    });
  });

}).call(this);

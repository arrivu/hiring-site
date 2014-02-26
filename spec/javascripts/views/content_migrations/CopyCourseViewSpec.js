(function() {
  define(['Backbone', 'compiled/models/ContentMigration', 'compiled/views/content_migrations/CopyCourseView', 'compiled/views/content_migrations/subviews/DateShiftView'], function(Backbone, ContentMigration, CopyCourseView, DateShiftView) {
    module('CopyCourseView: Initializer');
    return test('after init, calls updateNewDates when @courseFindSelect.triggers "course_changed" event', function() {
      var copyCourseView, course, sinonSpy;

      copyCourseView = new CopyCourseView({
        courseFindSelect: new Backbone.View,
        dateShift: new DateShiftView({
          collection: new Backbone.Collection,
          model: new ContentMigration
        })
      });
      $('#fixtures').html(copyCourseView.render().el);
      sinonSpy = sinon.spy(copyCourseView.dateShift, 'updateNewDates');
      course = {
        start_at: 'foo',
        end_at: 'bar'
      };
      copyCourseView.courseFindSelect.trigger('course_changed', course);
      ok(sinonSpy.calledWith(course), "Called updateNewDates with passed in object");
      return copyCourseView.remove();
    });
  });

}).call(this);

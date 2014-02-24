(function() {
  define(['Backbone', 'compiled/views/quizzes/NoQuizzesView', 'jquery', 'helpers/jquery.simulate'], function(Backbone, NoQuizzesView, $) {
    module('NoQuizzesView', {
      setup: function() {
        return this.view = new NoQuizzesView();
      }
    });
    return test('it renders', function() {
      return ok(this.view.$el.hasClass('item-group-condensed'));
    });
  });

}).call(this);

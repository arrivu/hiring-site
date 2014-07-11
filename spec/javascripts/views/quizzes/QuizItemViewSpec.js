(function() {
  define(['Backbone', 'compiled/models/Quiz', 'compiled/views/quizzes/QuizItemView', 'compiled/views/PublishIconView', 'jquery', 'helpers/jquery.simulate'], function(Backbone, Quiz, QuizItemView, PublishIconView, $) {
    var createView, fixtures;

    fixtures = $('#fixtures');
    createView = function(quiz) {
      var icon, view;

      if (quiz == null) {
        quiz = new Quiz({
          id: 1,
          title: 'Foo'
        });
      }
      icon = new PublishIconView({
        model: quiz
      });
      view = new QuizItemView({
        model: quiz,
        publishIconView: icon
      });
      view.$el.appendTo($('#fixtures'));
      return view.render();
    };
    module('QuizItemView', {
      setup: function() {}
    });
    test('renders admin if can_update', function() {
      var quiz, view;

      quiz = new Quiz({
        id: 1,
        title: 'Foo',
        can_update: true
      });
      view = createView(quiz);
      return equal(view.$('.ig-admin').length, 1);
    });
    test('doesnt render admin if can_update is false', function() {
      var quiz, view;

      quiz = new Quiz({
        id: 1,
        title: 'Foo',
        can_update: false
      });
      view = createView(quiz);
      return equal(view.$('.ig-admin').length, 0);
    });
    test('udpates publish status when model changes', function() {
      var quiz, view;

      quiz = new Quiz({
        id: 1,
        title: 'Foo',
        published: false
      });
      view = createView(quiz);
      ok(!view.$el.find(".ig-row").hasClass("ig-published"));
      quiz.set("published", true);
      return ok(view.$el.find(".ig-row").hasClass("ig-published"));
    });
    test('prompts confirm for delete', function() {
      var confirmed, quiz, view;

      quiz = new Quiz({
        id: 1,
        title: 'Foo',
        can_update: true
      });
      view = createView(quiz);
      quiz.destroy = function() {
        return true;
      };
      confirmed = false;
      window.confirm = function() {
        return confirmed = true;
      };
      view.$('.delete-item').simulate('click');
      return ok(confirmed);
    });
    test('confirm delete destroys model', function() {
      var destroyed, quiz, view;

      quiz = new Quiz({
        id: 1,
        title: 'Foo',
        can_update: true
      });
      view = createView(quiz);
      destroyed = false;
      quiz.destroy = function() {
        return destroyed = true;
      };
      view.$('.delete-item').simulate('click');
      return ok(destroyed);
    });
    test('doesnt redirect if clicking on ig-admin area', function() {
      var redirected, view;

      view = createView();
      redirected = false;
      view.redirectTo = function() {
        return redirected = true;
      };
      view.$('.ig-admin').simulate('click');
      return ok(!redirected);
    });
    return test('follows through when clicking on row', function() {
      var redirected, view;

      view = createView();
      redirected = false;
      view.redirectTo = function() {
        return redirected = true;
      };
      view.$('.ig-details').simulate('click');
      return ok(redirected);
    });
  });

}).call(this);

(function() {
  define(['Backbone', 'compiled/models/Quiz', 'compiled/collections/QuizCollection', 'compiled/views/quizzes/IndexView', 'compiled/views/quizzes/QuizItemGroupView', 'compiled/views/quizzes/NoQuizzesView', 'jquery', 'helpers/jquery.simulate'], function(Backbone, Quiz, QuizCollection, IndexView, QuizItemGroupView, NoQuizzesView, $) {
    var fixtures, indexView;

    fixtures = $('#fixtures');
    indexView = function(assignments, open, surveys) {
      var assignmentView, flags, noQuizzesView, openView, permissions, surveyView, urls, view;

      $('<div id="content"></div>').appendTo(fixtures);
      if (assignments == null) {
        assignments = new QuizCollection([]);
      }
      if (open == null) {
        open = new QuizCollection([]);
      }
      if (surveys == null) {
        surveys = new QuizCollection([]);
      }
      assignmentView = new QuizItemGroupView({
        collection: assignments,
        title: 'Assignment Quizzes',
        listId: 'assignment-quizzes',
        isSurvey: false
      });
      openView = new QuizItemGroupView({
        collection: open,
        title: 'Practice Quizzes',
        listId: 'open-quizzes',
        isSurvey: false
      });
      surveyView = new QuizItemGroupView({
        collection: surveys,
        title: 'Surveys',
        listId: 'surveys-quizzes',
        isSurvey: true
      });
      noQuizzesView = new NoQuizzesView;
      permissions = {
        create: true,
        manage: true
      };
      flags = {
        question_banks: true
      };
      urls = {
        new_quiz_url: '/courses/1/quizzes/new?fresh=1',
        question_banks_url: '/courses/1/question_banks'
      };
      view = new IndexView({
        assignmentView: assignmentView,
        openView: openView,
        surveyView: surveyView,
        noQuizzesView: noQuizzesView,
        permissions: permissions,
        flags: flags,
        urls: urls
      });
      view.$el.appendTo($('#fixtures'));
      return view.render();
    };
    module('IndexView', {
      setup: function() {}
    });
    test('#hasNoQuizzes if assignment and open quizzes are empty', function() {
      var assignments, open, view;

      assignments = new QuizCollection([]);
      open = new QuizCollection([]);
      view = indexView(assignments, open);
      return ok(view.options.hasNoQuizzes);
    });
    test('#hasNoQuizzes to false if has assignement quizzes', function() {
      var assignments, open, view;

      assignments = new QuizCollection([
        {
          id: 1
        }
      ]);
      open = new QuizCollection([]);
      view = indexView(assignments, open);
      return ok(!view.options.hasNoQuizzes);
    });
    test('#hasNoQuizzes to false if has open quizzes', function() {
      var assignments, open, view;

      assignments = new QuizCollection([]);
      open = new QuizCollection([
        {
          id: 1
        }
      ]);
      view = indexView(assignments, open);
      return ok(!view.options.hasNoQuizzes);
    });
    test('#hasAssignmentQuizzes if has assignment quizzes', function() {
      var assignments, view;

      assignments = new QuizCollection([
        {
          id: 1
        }
      ]);
      view = indexView(assignments, null, null);
      return ok(view.options.hasAssignmentQuizzes);
    });
    test('#hasOpenQuizzes if has open quizzes', function() {
      var open, view;

      open = new QuizCollection([
        {
          id: 1
        }
      ]);
      view = indexView(null, open, null);
      return ok(view.options.hasOpenQuizzes);
    });
    test('#hasSurveys if has surveys', function() {
      var surveys, view;

      surveys = new QuizCollection([
        {
          id: 1
        }
      ]);
      view = indexView(null, null, surveys);
      return ok(view.options.hasSurveys);
    });
    test('should render the view', function() {
      var assignments, open, view;

      assignments = new QuizCollection([
        {
          id: 1,
          title: 'Foo Title'
        }, {
          id: 2,
          title: 'Bar Title'
        }
      ]);
      open = new QuizCollection([
        {
          id: 3,
          title: 'Foo Title'
        }, {
          id: 4,
          title: 'Bar Title'
        }
      ]);
      view = indexView(assignments, open);
      return equal(view.$el.find('.collectionViewItems li').length, 4);
    });
    test('should filter by search term', function() {
      var assignments, open, view;

      assignments = new QuizCollection([
        {
          id: 1,
          title: 'Foo Name'
        }, {
          id: 2,
          title: 'Bar Title'
        }
      ]);
      open = new QuizCollection([
        {
          id: 3,
          title: 'Baz Title'
        }, {
          id: 4,
          title: 'Qux Name'
        }
      ]);
      view = indexView(assignments, open);
      $('#searchTerm').val('foo');
      view.filterResults();
      equal(view.$el.find('.collectionViewItems li').length, 1);
      view = indexView(assignments, open);
      $('#searchTerm').val('name');
      view.filterResults();
      return equal(view.$el.find('.collectionViewItems li').length, 2);
    });
    return test('should filter models with title that doesnt match term', function() {
      var model, view;

      view = indexView();
      model = new Quiz({
        title: "Foo Name"
      });
      ok(view.filter(model, "name"));
      return ok(!view.filter(model, "zzz"));
    });
  });

}).call(this);

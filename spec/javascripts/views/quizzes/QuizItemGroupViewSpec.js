(function() {
  define(['Backbone', 'compiled/models/Quiz', 'compiled/collections/QuizCollection', 'compiled/views/quizzes/QuizItemGroupView', 'jquery', 'helpers/jquery.simulate'], function(Backbone, Quiz, QuizCollection, QuizItemGroupView, $) {
    var createView, fixtures;

    fixtures = $('#fixtures');
    createView = function(collection) {
      var view;

      if (collection == null) {
        collection = new QuizCollection([
          {
            id: 1,
            title: 'Foo'
          }, {
            id: 2,
            title: 'Bar'
          }
        ]);
      }
      view = new QuizItemGroupView({
        collection: collection,
        listId: "assignment-quizzes"
      });
      view.$el.appendTo($('#fixtures'));
      return view.render();
    };
    module('QuizItemGroupView', test('#isEmpty is false if any items arent hidden', function() {
      var collection, view;

      collection = new QuizCollection([
        {
          id: 1,
          title: 'Foo'
        }, {
          id: 2,
          title: 'Bar'
        }
      ]);
      view = new createView(collection);
      return ok(!view.isEmpty());
    }));
    test('#isEmpty is true if collection is empty', function() {
      var collection, view;

      collection = new QuizCollection([]);
      view = new createView(collection);
      return ok(view.isEmpty());
    });
    test('#isEmpty is true if all items are hidden', function() {
      var collection, view;

      collection = new QuizCollection([
        {
          id: 1,
          hidden: true
        }, {
          id: 2,
          hidden: true
        }
      ]);
      view = new createView(collection);
      return ok(view.isEmpty());
    });
    test('should rerender on :hidden change', function() {
      var collection, quiz, view;

      collection = new QuizCollection([
        {
          id: 1
        }, {
          id: 2
        }
      ]);
      view = createView(collection);
      equal(view.$el.find('.collectionViewItems li').length, 2);
      quiz = collection.get(1);
      quiz.set('hidden', true);
      return equal(view.$el.find('.collectionViewItems li').length, 1);
    });
    test('should not render no content message if quizzes are available', function() {
      var collection, view;

      collection = new QuizCollection([
        {
          id: 1
        }, {
          id: 2
        }
      ]);
      view = createView(collection);
      equal(view.$el.find('.collectionViewItems li').length, 2);
      return ok(!view.$el.find('.no_content').is(':visible'));
    });
    test('should render no content message if no quizzes available', function() {
      var collection, view;

      collection = new QuizCollection([]);
      view = createView(collection);
      equal(view.$el.find('.collectionViewItems li').length, 0);
      return ok(view.$el.find('.no_content').is(':visible'));
    });
    return test('clicking the header should toggle arrow state', function() {
      var collection, view;

      collection = new QuizCollection([
        {
          id: 1
        }, {
          id: 2
        }
      ]);
      view = createView(collection);
      ok(view.$('.element_toggler i').hasClass('icon-mini-arrow-down'));
      ok(!view.$('.element_toggler i').hasClass('icon-mini-arrow-right'));
      view.$('.element_toggler').simulate('click');
      ok(!view.$('.element_toggler i').hasClass('icon-mini-arrow-down'));
      return ok(view.$('.element_toggler i').hasClass('icon-mini-arrow-right'));
    });
  });

}).call(this);

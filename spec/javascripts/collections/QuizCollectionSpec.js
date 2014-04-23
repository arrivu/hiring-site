(function() {
  define(['compiled/models/Quiz', 'compiled/collections/QuizCollection'], function(Quiz, QuizCollection) {
    return module('QuizCollection', test('builds a collection', function() {
      var collection;

      collection = new QuizCollection([
        new Quiz({
          id: 123
        })
      ]);
      return ok(collection.get(123));
    }));
  });

}).call(this);

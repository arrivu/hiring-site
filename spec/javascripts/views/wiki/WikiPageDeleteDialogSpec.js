(function() {
  define(['compiled/models/WikiPage', 'compiled/views/wiki/WikiPageDeleteDialog'], function(WikiPage, WikiPageDeleteDialog) {
    module('WikiPageDeleteDialog');
    return test('maintains the view of the model', function() {
      var dialog, model, view;

      model = new WikiPage;
      model.view = view = {};
      dialog = new WikiPageDeleteDialog({
        model: model
      });
      return equal(model.view, view, 'model.view is unaltered');
    });
  });

}).call(this);

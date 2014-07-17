(function() {
  define(['Backbone', 'jquery', 'compiled/views/InputView'], function(Backbone, $, InputView) {
    var setValue, view;

    view = null;
    module('InputView', {
      setup: function() {
        view = new InputView;
        view.render();
        return view.$el.appendTo($('#fixtures'));
      },
      teardown: function() {
        return view.remove();
      }
    });
    setValue = function(term) {
      return view.el.value = term;
    };
    test('updates the model attribute', function() {
      view.model = new Backbone.Model;
      setValue('foo');
      view.updateModel();
      return equal(view.model.get('unnamed'), 'foo');
    });
    test('updates the collection parameter', function() {
      var actual;

      view.collection = new Backbone.Collection;
      setValue('foo');
      view.updateModel();
      actual = view.collection.options.params.unnamed;
      return equal(actual, 'foo');
    });
    test('gets modelAttribute from input name', function() {
      var input;

      input = $('<input name="couch">').appendTo($('#fixtures'));
      view = new InputView({
        el: input[0]
      });
      return equal(view.modelAttribute, 'couch');
    });
    test('sets model attribute to empty string with empty value', function() {
      view.model = new Backbone.Model;
      setValue('foo');
      view.updateModel();
      setValue('');
      view.updateModel();
      return equal(view.model.get('unnamed'), '');
    });
    return test('deletes collection paramater on empty value', function() {
      view.collection = new Backbone.Collection;
      setValue('foo');
      view.updateModel();
      equal(view.collection.options.params.unnamed, 'foo');
      setValue('');
      view.updateModel();
      return strictEqual(view.collection.options.params.unnamed, void 0);
    });
  });

}).call(this);

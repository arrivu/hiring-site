(function() {
  define(['Backbone', 'compiled/views/SelectView', 'helpers/jquery.simulate'], function(Backbone, SelectView) {
    var view;

    view = null;
    module('SelectView', {
      setup: function() {
        view = new SelectView({
          template: function() {
            return "<option>foo</option>\n<option>bar</option>";
          }
        });
        view.render();
        return view.$el.appendTo($('#fixtures'));
      },
      teardown: function() {
        return view.remove();
      }
    });
    return test('onChange it updates the model', function() {
      view.model = new Backbone.Model;
      equal(view.el.value, 'foo');
      view.el.value = 'bar';
      equal(view.el.value, 'bar');
      view.$el.change();
      return equal(view.model.get('unnamed'), 'bar');
    });
  });

}).call(this);

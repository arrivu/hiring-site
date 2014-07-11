(function() {
  define(['Backbone', 'jquery', 'compiled/views/InputFilterView', 'helpers/jquery.simulate'], function(Backbone, $, InputFilterView) {
    var clock, setValue, simulateKeyup, view;

    view = null;
    clock = null;
    module('InputFilterView', {
      setup: function() {
        clock = sinon.useFakeTimers();
        view = new InputFilterView;
        view.render();
        return view.$el.appendTo($('#fixtures'));
      },
      teardown: function() {
        clock.restore();
        return view.remove();
      }
    });
    setValue = function(term) {
      return view.el.value = term;
    };
    simulateKeyup = function(opts) {
      if (opts == null) {
        opts = {};
      }
      view.$el.simulate('keyup', opts);
      return clock.tick(view.options.onInputDelay);
    };
    test('fires input event, sends value', function() {
      var spy;

      spy = sinon.spy();
      view.on('input', spy);
      setValue('foo');
      simulateKeyup();
      ok(spy.called);
      return ok(spy.calledWith('foo'));
    });
    test('does not fire input event if value has not changed', function() {
      var spy;

      spy = sinon.spy();
      view.on('input', spy);
      setValue('foo');
      simulateKeyup();
      simulateKeyup();
      return ok(spy.calledOnce);
    });
    test('updates the model attribute', function() {
      view.model = new Backbone.Model;
      setValue('foo');
      simulateKeyup();
      return equal(view.model.get('filter'), 'foo');
    });
    test('updates the collection parameter', function() {
      var actual;

      view.collection = new Backbone.Collection;
      setValue('foo');
      simulateKeyup();
      actual = view.collection.options.params.filter;
      return equal(actual, 'foo');
    });
    test('gets modelAttribute from input name', function() {
      var input;

      input = $('<input name="couch">').appendTo($('#fixtures'));
      view = new InputFilterView({
        el: input[0]
      });
      return equal(view.modelAttribute, 'couch');
    });
    test('sets model attribute to empty string with empty value', function() {
      view.model = new Backbone.Model;
      setValue('foo');
      simulateKeyup();
      setValue('');
      simulateKeyup();
      return equal(view.model.get('filter'), '');
    });
    test('deletes collection paramater on empty value', function() {
      view.collection = new Backbone.Collection;
      setValue('foo');
      simulateKeyup();
      equal(view.collection.options.params.filter, 'foo');
      setValue('');
      simulateKeyup();
      return strictEqual(view.collection.options.params.filter, void 0);
    });
    test('does nothing with model/collection when the value is less than the minLength', function() {
      view.model = new Backbone.Model({
        filter: 'foo'
      });
      setValue('ab');
      simulateKeyup();
      return equal(view.model.get('filter'), 'foo', 'filter attribute did not change');
    });
    test('does setParam false when the value is less than the minLength and setParamOnInvalid=true', function() {
      view.model = new Backbone.Model({
        filter: 'foo'
      });
      view.options.setParamOnInvalid = true;
      setValue('ab');
      simulateKeyup();
      return equal(view.model.get('filter'), false, 'filter attribute is false');
    });
    return test('updates filter with small number', function() {
      view.model = new Backbone.Model({
        filter: 'foo'
      });
      view.options.allowSmallerNumbers = false;
      setValue('1');
      simulateKeyup();
      equal(view.model.get('filter'), 'foo', 'filter attribute did not change');
      view.options.allowSmallerNumbers = true;
      setValue('2');
      simulateKeyup();
      return equal(view.model.get('filter'), '2', 'filter attribute did change');
    });
  });

}).call(this);

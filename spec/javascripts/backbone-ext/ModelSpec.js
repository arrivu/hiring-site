(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['Backbone'], function(_arg) {
    var Model;

    Model = _arg.Model;
    module('Backbone.Model', {
      setup: function() {
        return this.model = new Model;
      }
    });
    test('@mixin', function() {
      var Mixed, initSpy, mixable, model, _ref;

      initSpy = sinon.spy();
      mixable = {
        defaults: {
          cash: 'money'
        },
        initialize: initSpy
      };
      Mixed = (function(_super) {
        __extends(Mixed, _super);

        function Mixed() {
          _ref = Mixed.__super__.constructor.apply(this, arguments);
          return _ref;
        }

        Mixed.mixin(mixable);

        Mixed.prototype.initialize = function() {
          initSpy.apply(this, arguments);
          return Mixed.__super__.initialize.apply(this, arguments);
        };

        return Mixed;

      })(Model);
      model = new Mixed;
      equal(model.get('cash'), 'money', 'mixes in defaults');
      return ok(initSpy.calledTwice, 'inherits initialize');
    });
    test('increment', function() {
      var model;

      model = new Model({
        count: 1
      });
      model.increment('count', 2);
      return equal(model.get('count'), 3);
    });
    test('decrement', function() {
      var model;

      model = new Model({
        count: 10
      });
      model.decrement('count', 7);
      return equal(model.get('count'), 3);
    });
    return test('#deepGet returns nested attributes', function() {
      var value;

      this.model.attributes = {
        foo: {
          bar: {
            zing: 'cats'
          }
        }
      };
      value = this.model.deepGet('foo.bar.zing');
      return equal(value, 'cats', 'gets a nested attribute');
    });
  });

}).call(this);

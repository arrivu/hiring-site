(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['Backbone'], function(_arg) {
    var View;

    View = _arg.View;
    module('View');
    test('defaults', function() {
      var SomeView, view, _ref;

      SomeView = (function(_super) {
        __extends(SomeView, _super);

        function SomeView() {
          _ref = SomeView.__super__.constructor.apply(this, arguments);
          return _ref;
        }

        SomeView.prototype.defaults = {
          foo: 'bar'
        };

        return SomeView;

      })(Backbone.View);
      view = new SomeView;
      equal(view.options.foo, 'bar', 'recieves default');
      view = new SomeView({
        foo: 'baz'
      });
      equal(view.options.foo, 'baz', 'overrides default');
      return equal(SomeView.prototype.defaults.foo, 'bar', "doesn't extend prototype");
    });
    test('els config', function() {
      var SomeView, view, _ref;

      SomeView = (function(_super) {
        __extends(SomeView, _super);

        function SomeView() {
          _ref = SomeView.__super__.constructor.apply(this, arguments);
          return _ref;
        }

        SomeView.prototype.els = {
          '.foo': '$bar'
        };

        SomeView.prototype.template = function() {
          return "<div class='foo'>foo</div>";
        };

        return SomeView;

      })(Backbone.View);
      view = new SomeView;
      view.render();
      return equal(view.$bar.html(), 'foo', 'cached element');
    });
    test('optionProperty', function() {
      var SomeView, view, _ref;

      SomeView = (function(_super) {
        __extends(SomeView, _super);

        function SomeView() {
          _ref = SomeView.__super__.constructor.apply(this, arguments);
          return _ref;
        }

        SomeView.optionProperty('foo');

        return SomeView;

      })(Backbone.View);
      view = new SomeView({
        foo: 'bar'
      });
      equal(view.foo, 'bar', 'set option as instance property');
      view = new Backbone.View({
        foo: 'bar'
      });
      return ok(view.foo == null, 'parent class property options not poluted');
    });
    test('children should have a list of child views', function() {
      var SomeView, view, _ref;

      SomeView = (function(_super) {
        __extends(SomeView, _super);

        function SomeView() {
          _ref = SomeView.__super__.constructor.apply(this, arguments);
          return _ref;
        }

        SomeView.child('test', '.test');

        return SomeView;

      })(Backbone.View);
      view = new SomeView({
        test: new Backbone.View
      });
      return equal(view.children.length, 1, "Creates an array of children view stored on .children");
    });
    test('template optionProperty', function() {
      var view;

      view = new View({
        template: function() {
          return "hi";
        }
      });
      view.render();
      return equal(view.$el.html(), "hi", "template rendered with view as option");
    });
    test('child views', function() {
      var ChildView, ParentView, child, parent, _ref, _ref1;

      ChildView = (function(_super) {
        __extends(ChildView, _super);

        function ChildView() {
          _ref = ChildView.__super__.constructor.apply(this, arguments);
          return _ref;
        }

        ChildView.prototype.template = function() {
          return "hi";
        };

        return ChildView;

      })(View);
      ParentView = (function(_super) {
        __extends(ParentView, _super);

        function ParentView() {
          _ref1 = ParentView.__super__.constructor.apply(this, arguments);
          return _ref1;
        }

        ParentView.optionProperty(ParentView, 'fart');

        ParentView.child('childView', '#child');

        ParentView.prototype.template = function() {
          return "<div id='child'></div>";
        };

        return ParentView;

      })(View);
      child = new ChildView;
      parent = new ParentView({
        childView: child,
        fart: 'fart'
      });
      parent.render();
      equal(parent.$el.find('#child').html(), 'hi', 'child view rendered');
      return ok(parent.childView, 'childView assigned as instance property');
    });
    test('initialize', function() {
      var collection, model, view;

      model = new Backbone.Model;
      collection = new Backbone.Collection;
      view = new Backbone.View({
        model: model,
        collection: collection
      });
      equal(view.$el.data('view'), view, 'view stored on element data');
      equal(model.view, view, 'sets model.view to the view');
      return equal(collection.view, view, 'sets collection.view to the view');
    });
    test('render', function() {
      var SomeView, view, _ref;

      SomeView = (function(_super) {
        __extends(SomeView, _super);

        function SomeView() {
          _ref = SomeView.__super__.constructor.apply(this, arguments);
          return _ref;
        }

        SomeView.prototype.template = function() {
          return 'hi';
        };

        return SomeView;

      })(Backbone.View);
      view = new SomeView;
      view.render();
      return equal(view.$el.html(), 'hi', 'renders template');
    });
    test('data-bind', function() {
      var SomeView, model, view, _ref;

      SomeView = (function(_super) {
        __extends(SomeView, _super);

        function SomeView() {
          _ref = SomeView.__super__.constructor.apply(this, arguments);
          return _ref;
        }

        SomeView.prototype.els = {
          '#name': '$name',
          '#title': '$title'
        };

        SomeView.prototype.template = function(_arg1) {
          var name, title;

          name = _arg1.name, title = _arg1.title;
          return "<i id='name' data-bind='name'>" + name + "</i>\n<i id='title' data-bind='title'>" + title + "</i>";
        };

        SomeView.prototype.format = function(attr, value) {
          if (attr === 'title') {
            return 'formatted';
          } else {
            return value;
          }
        };

        return SomeView;

      })(Backbone.View);
      model = new Backbone.Model;
      view = new SomeView({
        model: model
      });
      view.render();
      model.set('name', 'ryanf');
      equal(view.$name.html(), 'ryanf', 'set template to model data');
      model.set('name', 'jon');
      equal(view.$name.html(), 'jon', 'element html kept up-to-date');
      model.set('title', 'engineer');
      return equal(view.$title.html(), 'formatted', 'formatting applied');
    });
    test('toJSON', function() {
      var collection, expected, model, view;

      view = new Backbone.View({
        foo: 'bar'
      });
      expected = {
        foo: 'bar',
        cid: view.cid
      };
      deepEqual(expected, view.toJSON(), 'returns options');
      collection = new Backbone.Collection;
      collection.toJSON = function() {
        return {
          foo: 'bar'
        };
      };
      view = new Backbone.View({
        collection: collection
      });
      expected = {
        foo: 'bar',
        cid: view.cid
      };
      deepEqual(expected, view.toJSON(), 'uses @collection.toJSON');
      collection.present = function() {
        return {
          foo: 'baz'
        };
      };
      expected = {
        foo: 'baz',
        cid: view.cid
      };
      deepEqual(expected, view.toJSON(), 'uses @collection.present over toJSON');
      model = new Backbone.Model;
      model.toJSON = function() {
        return {
          foo: 'qux'
        };
      };
      view.model = model;
      expected = {
        foo: 'qux',
        cid: view.cid
      };
      deepEqual(expected, view.toJSON(), 'uses @model.toJSON over @collection');
      model.present = function() {
        return {
          foo: 'quux'
        };
      };
      expected = {
        foo: 'quux',
        cid: view.cid
      };
      return deepEqual(expected, view.toJSON(), 'uses @model.present over toJSON');
    });
    test('View.mixin', 3, function() {
      var SomeView, expectedEvents, mixin1, mixin2, view, _ref;

      mixin1 = {
        events: {
          'click .foo': 'foo'
        },
        foo: function() {
          return ok(true, 'called mixin1.foo');
        }
      };
      mixin2 = {
        events: {
          'click .bar': 'bar'
        },
        bar: function() {
          return ok(true, 'called mixin2.bar');
        }
      };
      SomeView = (function(_super) {
        __extends(SomeView, _super);

        function SomeView() {
          _ref = SomeView.__super__.constructor.apply(this, arguments);
          return _ref;
        }

        SomeView.prototype.events = {
          'click .baz': 'baz'
        };

        SomeView.prototype.baz = function() {
          return ok(true, 'called prototype method baz');
        };

        SomeView.mixin(mixin1, mixin2);

        return SomeView;

      })(View);
      view = new SomeView;
      expectedEvents = {
        'click .foo': 'foo',
        'click .bar': 'bar',
        'click .baz': 'baz'
      };
      deepEqual(view.events, expectedEvents, 'events merged properly');
      view.foo();
      return view.bar();
    });
    test('View.mixin initialize, attach and afterRender magic tricks', function() {
      var SomeView, mixin1, mixin2, view, _ref;

      mixin1 = {
        initialize: sinon.spy(),
        attach: sinon.spy(),
        afterRender: sinon.spy()
      };
      mixin2 = {
        initialize: sinon.spy(),
        attach: sinon.spy(),
        afterRender: sinon.spy()
      };
      SomeView = (function(_super) {
        __extends(SomeView, _super);

        function SomeView() {
          _ref = SomeView.__super__.constructor.apply(this, arguments);
          return _ref;
        }

        SomeView.mixin(mixin1, mixin2);

        return SomeView;

      })(View);
      view = new SomeView;
      view.render();
      ok(mixin1.initialize.calledOnce, 'called mixin1 initialize');
      ok(mixin2.initialize.calledOnce, 'called mixin2 initialize');
      ok(mixin1.afterRender.calledOnce, 'called mixin1 afterRender');
      ok(mixin2.afterRender.calledOnce, 'called mixin2 afterRender');
      ok(mixin1.attach.calledOnce, 'called mixin1 attach');
      return ok(mixin2.attach.calledOnce, 'called mixin2 attach');
    });
    return test('View.mixin does not merge into parent class', function() {
      var Foo, mixin, _ref;

      mixin = {
        defaults: {
          foo: 'bar'
        }
      };
      Foo = (function(_super) {
        __extends(Foo, _super);

        function Foo() {
          _ref = Foo.__super__.constructor.apply(this, arguments);
          return _ref;
        }

        Foo.mixin(mixin);

        return Foo;

      })(View);
      equal(View.prototype.defaults.foo, void 0, 'View::defaults was not appended');
      return equal(Foo.prototype.defaults.foo, 'bar', 'Foo::defaults was appended');
    });
  });

}).call(this);

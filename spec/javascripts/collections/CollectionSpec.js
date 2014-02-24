(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['Backbone'], function(Backbone) {
    var TestCollection, _ref;

    TestCollection = (function(_super) {
      __extends(TestCollection, _super);

      function TestCollection() {
        _ref = TestCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      TestCollection.prototype.defaults = {
        foo: 'bar',
        params: {
          multi: ['foos', 'bars'],
          single: 1
        }
      };

      TestCollection.optionProperty('foo');

      TestCollection.prototype.url = '/fake';

      TestCollection.prototype.model = Backbone.Model.extend();

      return TestCollection;

    })(Backbone.Collection);
    module('Backbone.Collection', {
      setup: function() {
        return this.ajaxSpy = sinon.spy($, 'ajax');
      },
      teardown: function() {
        return $.ajax.restore();
      }
    });
    test('default options', function() {
      var collection, collection2;

      collection = new TestCollection();
      equal(typeof collection.options, 'object', 'sets options property');
      equal(collection.options.foo, 'bar', 'sets default options');
      collection2 = new TestCollection(null, {
        foo: 'baz'
      });
      return equal(collection2.options.foo, 'baz', 'overrides default options with instance options');
    });
    test('optionProperty', function() {
      var collection;

      collection = new TestCollection({
        foo: 'bar'
      });
      return equal(collection.foo, 'bar');
    });
    test('sends @params in request', function() {
      var collection;

      collection = new TestCollection();
      collection.fetch();
      deepEqual($.ajax.getCall(0).args[0].data, collection.options.params, 'sends default parameters with request');
      collection.options.params = {
        a: 'b',
        c: ['d']
      };
      collection.fetch();
      return deepEqual($.ajax.getCall(1).args[0].data, collection.options.params, 'sends dynamic parameters with request');
    });
    test('uses conventional default url', function() {
      var FakeCollection, FakeModel, assetString, collection;

      FakeModel = Backbone.Model.extend({
        resourceName: 'discussion_topics'
      }, assetString = 'course_1');
      FakeCollection = Backbone.Collection.extend({
        model: FakeModel
      });
      collection = new FakeCollection();
      collection.contextAssetString = assetString;
      return equal(collection.url(), '/api/v1/courses/1/discussion_topics', 'used conventional URL with specific contextAssetString');
    });
    test('triggers setParam event', function() {
      var collection, spy;

      collection = new Backbone.Collection;
      spy = sinon.spy();
      collection.on('setParam', spy);
      collection.setParam('foo', 'bar');
      ok(spy.calledOnce, 'event triggered');
      equal(spy.args[0][0], 'foo');
      return equal(spy.args[0][1], 'bar');
    });
    test('setParams', function() {
      var collection;

      collection = new Backbone.Collection;
      ok(!collection.options.params, 'no params');
      collection.setParams({
        foo: 'bar',
        baz: 'qux'
      });
      return deepEqual(collection.options.params, {
        foo: 'bar',
        baz: 'qux'
      });
    });
    test('triggers setParams event', function() {
      var collection, params, spy;

      collection = new Backbone.Collection;
      spy = sinon.spy();
      collection.on('setParams', spy);
      params = {
        foo: 'bar',
        baz: 'qux'
      };
      collection.setParams(params);
      ok(spy.calledOnce, 'event triggered');
      return equal(spy.args[0][0], params);
    });
    return test('parse', function() {
      var SideLoader, collection, document, expected, jane, john, _ref1;

      SideLoader = (function(_super) {
        __extends(SideLoader, _super);

        function SideLoader() {
          _ref1 = SideLoader.__super__.constructor.apply(this, arguments);
          return _ref1;
        }

        return SideLoader;

      })(Backbone.Collection);
      collection = new SideLoader;
      SideLoader.prototype.sideLoad = {
        author: true
      };
      document = [1, 2, 3];
      equal(collection.parse(document), document, 'passes through simple documents');
      document = {
        a: 1,
        b: 2
      };
      equal(collection.parse(document), document, 'passes through without meta key');
      document = {
        meta: {
          primaryCollection: 'posts'
        },
        posts: [
          {
            id: 1,
            author_id: 1
          }, {
            id: 2,
            author_id: 1
          }
        ]
      };
      equal(collection.parse(document), document.posts, 'extracts primary collection');
      john = {
        id: 1,
        name: "John Doe"
      };
      document = {
        meta: {
          primaryCollection: 'posts'
        },
        posts: [
          {
            id: 1,
            author_id: 1
          }, {
            id: 2,
            author_id: 1
          }
        ],
        authors: [john]
      };
      expected = [
        {
          id: 1,
          author: john
        }, {
          id: 2,
          author: john
        }
      ];
      deepEqual(collection.parse(document), expected, 'extracts primary collection');
      SideLoader.prototype.sideLoad = {
        author: 'users'
      };
      document = {
        meta: {
          primaryCollection: 'posts'
        },
        posts: [
          {
            id: 1,
            author_id: 1
          }, {
            id: 2,
            author_id: 1
          }
        ],
        users: [john]
      };
      deepEqual(collection.parse(document), expected, 'recognizes string side load as collection name');
      SideLoader.prototype.sideLoad = {
        author: {
          collection: 'users',
          foreignKey: 'user_id'
        }
      };
      document = {
        meta: {
          primaryCollection: 'posts'
        },
        posts: [
          {
            id: 1,
            user_id: 1
          }, {
            id: 2,
            user_id: 1
          }
        ],
        users: [john]
      };
      deepEqual(collection.parse(document), expected, 'recognizes complex side load declaration');
      SideLoader.prototype.sideLoad = {
        author: 'users',
        editor: 'users'
      };
      jane = {
        id: 2,
        name: "Jane Doe"
      };
      document = {
        meta: {
          primaryCollection: 'posts'
        },
        posts: [
          {
            id: 1,
            author_id: 1,
            editor_id: 2
          }, {
            id: 2,
            author_id: 2,
            editor_id: 1
          }
        ],
        users: [john, jane]
      };
      expected = [
        {
          id: 1,
          author: john,
          editor: jane
        }, {
          id: 2,
          author: jane,
          editor: john
        }
      ];
      return deepEqual(collection.parse(document), expected, 'recognizes multiple side load declarations');
    });
  });

}).call(this);

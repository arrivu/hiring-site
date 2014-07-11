(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'Backbone', 'compiled/views/SearchView', 'compiled/views/InputFilterView', 'compiled/views/CollectionView', 'helpers/jquery.simulate'], function($, Backbone, SearchView, InputFilterView, CollectionView) {
    var TestCollection, TestItemView, assertRenderedItems, clock, collection, searchView, sendResponse, sendSearchResponse, server, setSearchTo, simulateKeyup, view, _ref, _ref1;

    view = null;
    collection = null;
    clock = null;
    server = null;
    searchView = null;
    TestCollection = (function(_super) {
      __extends(TestCollection, _super);

      function TestCollection() {
        _ref = TestCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      TestCollection.prototype.url = '/test';

      return TestCollection;

    })(Backbone.Collection);
    TestItemView = (function(_super) {
      __extends(TestItemView, _super);

      function TestItemView() {
        _ref1 = TestItemView.__super__.constructor.apply(this, arguments);
        return _ref1;
      }

      TestItemView.prototype.template = function(_arg) {
        var name;

        name = _arg.name;
        return name;
      };

      return TestItemView;

    })(Backbone.View);
    module('SearchView', {
      setup: function() {
        var collectionView, inputFilterView;

        collection = new TestCollection;
        inputFilterView = new InputFilterView;
        collectionView = new CollectionView({
          collection: collection,
          itemView: TestItemView
        });
        searchView = new SearchView({
          inputFilterView: inputFilterView,
          collectionView: collectionView
        });
        searchView.$el.appendTo($('#fixtures'));
        searchView.render();
        clock = sinon.useFakeTimers();
        server = sinon.fakeServer.create();
        window.searchView = searchView;
        return window.collection = collection;
      },
      teardown: function() {
        clock.restore();
        server.restore();
        return searchView.remove();
      }
    });
    assertRenderedItems = function(names) {
      var el, items, joinedItems, joinedModels, joinedNames;

      if (names == null) {
        names = [];
      }
      items = searchView.collectionView.$list.children();
      equal(items.length, names.length, 'items length matches');
      joinedItems = ((function() {
        var _i, _len, _results;

        _results = [];
        for (_i = 0, _len = items.length; _i < _len; _i++) {
          el = items[_i];
          _results.push(el.innerHTML);
        }
        return _results;
      })()).join(' ');
      joinedNames = names.join(' ');
      joinedModels = collection.map(function(item) {
        return item.get('name');
      }).join(' ');
      equal(joinedModels, joinedNames, 'collection order matches');
      return equal(joinedItems, joinedNames, 'dom order matches');
    };
    setSearchTo = function(term) {
      return searchView.inputFilterView.el.value = term;
    };
    simulateKeyup = function(opts) {
      if (opts == null) {
        opts = {};
      }
      return searchView.inputFilterView.$el.simulate('keyup', opts);
    };
    sendResponse = function(url, json) {
      return server.respond('GET', url, [
        200, {
          'Content-Type': 'application/json'
        }, JSON.stringify(json)
      ]);
    };
    sendSearchResponse = function(json) {
      var search, url;

      clock.tick(searchView.inputFilterView.options.onInputDelay);
      search = searchView.inputFilterView.el.value;
      url = "" + collection.url + "?search_term=" + search;
      return sendResponse(url, json);
    };
    test('renders results on input', function() {
      setSearchTo('ryan');
      simulateKeyup();
      sendSearchResponse([
        {
          name: 'ryanf'
        }, {
          name: 'ryanh'
        }
      ]);
      return assertRenderedItems(['ryanf', 'ryanh']);
    });
    test('renders results on enter', function() {
      setSearchTo('ryan');
      simulateKeyup({
        keyCode: 13
      });
      sendSearchResponse([
        {
          name: 'ryanf'
        }, {
          name: 'ryanh'
        }
      ]);
      return assertRenderedItems(['ryanf', 'ryanh']);
    });
    return test('replaces old results', function() {
      setSearchTo('ryan');
      simulateKeyup();
      sendSearchResponse([
        {
          name: 'ryanf'
        }, {
          name: 'ryanh'
        }
      ]);
      assertRenderedItems(['ryanf', 'ryanh']);
      setSearchTo('jon');
      simulateKeyup();
      sendSearchResponse([
        {
          name: 'jon'
        }, {
          name: 'jonw'
        }
      ]);
      return assertRenderedItems(['jon', 'jonw']);
    });
  });

}).call(this);

(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['Backbone', 'compiled/views/CollectionView'], function(Backbone, CollectionView) {
    var Collection, ItemView, assertEmptyTemplateRendered, assertItemRendered, assertRenderedItems, collection, view, _ref, _ref1;

    collection = null;
    view = null;
    Collection = (function(_super) {
      __extends(Collection, _super);

      function Collection() {
        _ref = Collection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Collection.prototype.model = Backbone.Model;

      Collection.prototype.comparator = function(a, b) {
        if (a.get('id') < b.get('id')) {
          return 1;
        } else {
          return -1;
        }
      };

      return Collection;

    })(Backbone.Collection);
    ItemView = (function(_super) {
      __extends(ItemView, _super);

      function ItemView() {
        _ref1 = ItemView.__super__.constructor.apply(this, arguments);
        return _ref1;
      }

      ItemView.prototype.tagName = 'li';

      ItemView.prototype.template = function(_arg) {
        var name;

        name = _arg.name;
        return name;
      };

      ItemView.prototype.remove = function() {
        var _base, _ref2;

        ItemView.__super__.remove.apply(this, arguments);
        if ((_ref2 = (_base = this.constructor)['testing removed']) == null) {
          _base['testing removed'] = 0;
        }
        return this.constructor['testing removed']++;
      };

      return ItemView;

    })(Backbone.View);
    module('CollectionView', {
      setup: function() {
        collection = new Collection([
          {
            name: 'Jon',
            id: 24
          }, {
            name: 'Ryan',
            id: 56
          }
        ]);
        view = new CollectionView({
          collection: collection,
          emptyTemplate: function() {
            return "No Results";
          },
          itemView: ItemView
        });
        view.$el.appendTo($('#fixtures'));
        return view.render();
      },
      teardown: function() {
        ItemView['testing removed'] = 0;
        return view.remove();
      }
    });
    assertRenderedItems = function(names) {
      var el, items, joinedItems, joinedModels, joinedNames;

      if (names == null) {
        names = [];
      }
      items = view.$list.children();
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
    assertItemRendered = function(name) {
      var $match;

      $match = view.$list.children().filter(function(i, el) {
        return el.innerHTML === name;
      });
      return ok($match.length, 'item found');
    };
    assertEmptyTemplateRendered = function() {
      return ok(view.$el.text().match(/No items/), 'empty template rendered');
    };
    test('renders added items', function() {
      collection.reset();
      collection.add({
        name: 'Joe',
        id: 110
      });
      return assertRenderedItems(['Joe']);
    });
    test('renders empty template', function() {
      collection.reset();
      assertRenderedItems();
      return assertEmptyTemplateRendered();
    });
    test('renders empty template when last item is removed', function() {
      collection.remove(collection.get(24));
      collection.remove(collection.get(56));
      assertRenderedItems();
      return assertEmptyTemplateRendered();
    });
    test('removes empty template on add', function() {
      collection.reset();
      assertEmptyTemplateRendered();
      collection.add({
        name: 'Joe',
        id: 110
      });
      ok(!view.$el.text().match(/No items/), 'empty template removed');
      return assertItemRendered('Joe');
    });
    test('removes items and re-renders on collection reset', function() {
      collection.reset([
        {
          name: 'Joe',
          id: 110
        }
      ]);
      equal(ItemView['testing removed'], 2);
      return assertRenderedItems(['Joe']);
    });
    test('items are removed from view when removed from collection', function() {
      collection.remove(collection.get(24));
      return assertRenderedItems(['Ryan']);
    });
    return test('added items respect comparator', function() {
      collection.add({
        name: 'Joe',
        id: 110
      });
      assertRenderedItems(['Joe', 'Ryan', 'Jon']);
      collection.add({
        name: 'Cam',
        id: 106
      });
      assertRenderedItems(['Joe', 'Cam', 'Ryan', 'Jon']);
      collection.add({
        name: 'Brian',
        id: 1
      });
      return assertRenderedItems(['Joe', 'Cam', 'Ryan', 'Jon', 'Brian']);
    });
  });

}).call(this);

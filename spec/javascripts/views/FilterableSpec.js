(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['compiled/views/Filterable', 'Backbone', 'compiled/views/CollectionView'], function(Filterable, _arg, CollectionView) {
    var Collection, View, view;

    Collection = _arg.Collection, View = _arg.View;
    view = null;
    module('Filterable', {
      setup: function() {
        var MyCollectionView, collection, _ref;

        MyCollectionView = (function(_super) {
          __extends(MyCollectionView, _super);

          function MyCollectionView() {
            _ref = MyCollectionView.__super__.constructor.apply(this, arguments);
            return _ref;
          }

          MyCollectionView.mixin(Filterable);

          MyCollectionView.prototype.template = function() {
            return "<input class=\"filterable\">\n<div class=\"collectionViewItems\"></div>";
          };

          return MyCollectionView;

        })(CollectionView);
        collection = new Collection([
          {
            id: 1,
            name: "bob"
          }, {
            id: 2,
            name: "joe"
          }
        ]);
        view = new MyCollectionView({
          collection: collection,
          itemView: View
        });
        return view.render();
      }
    });
    return test('hides items that don\'t match the filter', function() {
      equal(view.$list.children().length, 2);
      equal(view.$list.children('.hidden').length, 0);
      view.$filter.val("b");
      view.$filter.trigger('input');
      equal(view.$list.children().length, 2);
      equal(view.$list.children('.hidden').length, 1);
      view.$filter.val("bb");
      view.$filter.trigger('input');
      equal(view.$list.children().length, 2);
      equal(view.$list.children('.hidden').length, 2);
      view.$filter.val("B");
      view.$filter.trigger('input');
      equal(view.$list.children().length, 2);
      return equal(view.$list.children('.hidden').length, 1);
    });
  });

}).call(this);

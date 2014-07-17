(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'compiled/collections/PaginatedCollection', 'compiled/views/PaginatedCollectionView', 'helpers/getFakePage'], function($, PaginatedCollection, PaginatedCollectionView, fakePage) {
    var ItemView, TestCollection, assertItemRendered, clock, collection, createServer, fixtures, scrollToBottom, server, view, _ref, _ref1;

    server = null;
    clock = null;
    collection = null;
    view = null;
    fixtures = $('#fixtures');
    createServer = function() {
      server = sinon.fakeServer.create();
      return server.sendPage = function(page, url) {
        return this.respond('GET', url, [
          200, {
            'Content-Type': 'application/json',
            'Link': page.header
          }, JSON.stringify(page.data)
        ]);
      };
    };
    ItemView = (function(_super) {
      __extends(ItemView, _super);

      function ItemView() {
        _ref = ItemView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      ItemView.prototype.tagName = 'li';

      ItemView.prototype.template = function(_arg) {
        var id;

        id = _arg.id;
        return id;
      };

      ItemView.prototype.initialize = function() {
        return this.$el.css('height', 500);
      };

      return ItemView;

    })(Backbone.View);
    TestCollection = (function(_super) {
      __extends(TestCollection, _super);

      function TestCollection() {
        _ref1 = TestCollection.__super__.constructor.apply(this, arguments);
        return _ref1;
      }

      TestCollection.prototype.url = '/test';

      return TestCollection;

    })(PaginatedCollection);
    module('PaginatedCollectionView', {
      setup: function() {
        fixtures.css({
          height: 500,
          overflow: 'auto'
        });
        createServer();
        clock = sinon.useFakeTimers();
        collection = new TestCollection;
        view = new PaginatedCollectionView({
          collection: collection,
          itemView: ItemView,
          scrollContainer: fixtures
        });
        view.$el.appendTo(fixtures);
        return view.render();
      },
      teardown: function() {
        server.restore();
        clock.restore();
        fixtures.attr('style', '');
        return view.remove();
      }
    });
    assertItemRendered = function(id) {
      var $match;

      $match = view.$list.children().filter(function(i, el) {
        return el.innerHTML === id;
      });
      return ok($match.length, 'item found');
    };
    scrollToBottom = function() {
      fixtures[0].scrollTop = view.$el.position().top + view.$el.height() - fixtures.position().top - 100;
      return ok(fixtures[0].scrollTop > 0);
    };
    test('renders items', function() {
      collection.add({
        id: 1
      });
      return assertItemRendered('1');
    });
    test('renders items on collection fetch and fetch next', function() {
      collection.fetch();
      server.sendPage(fakePage(), collection.url);
      assertItemRendered('1');
      assertItemRendered('2');
      collection.fetch({
        page: 'next'
      });
      server.sendPage(fakePage(2), collection.urls.next);
      assertItemRendered('3');
      return assertItemRendered('4');
    });
    test('fetches the next page on scroll', function() {
      collection.fetch();
      server.sendPage(fakePage(), collection.url);
      scrollToBottom();
      view.checkScroll();
      ok(collection.fetchingNextPage, 'collection is fetching');
      server.sendPage(fakePage(2), collection.urls.next);
      assertItemRendered('3');
      return assertItemRendered('4');
    });
    test('doesn\'t fetch if already fetching', function() {
      sinon.spy(collection, 'fetch');
      sinon.spy(view, 'hideLoadingIndicator');
      collection.fetch();
      view.checkScroll();
      ok(collection.fetch.calledOnce, 'fetch called once');
      return ok(!view.hideLoadingIndicator.called, 'hideLoadingIndicator not called');
    });
    test('auto-fetches visible pages', function() {
      view.remove();
      view = new PaginatedCollectionView({
        collection: collection,
        itemView: ItemView,
        scrollContainer: fixtures,
        autoFetch: true
      });
      view.$el.appendTo(fixtures);
      view.render();
      fixtures.css({
        height: 1000
      });
      collection.fetch();
      server.sendPage(fakePage(), collection.url);
      assertItemRendered('1');
      assertItemRendered('2');
      clock.tick(0);
      server.sendPage(fakePage(2), collection.urls.next);
      assertItemRendered('3');
      return assertItemRendered('4');
    });
    return test('stops fetching pages after the last page', function() {
      var fakeEvent, i, _i;

      fakeEvent = "foo.pagination:" + view.cid;
      fixtures.on(fakeEvent, function() {
        return ok(false, 'this should never run');
      });
      collection.fetch();
      server.sendPage(fakePage(), collection.url);
      for (i = _i = 2; _i <= 10; i = ++_i) {
        collection.fetch({
          page: 'next'
        });
        server.sendPage(fakePage(i), collection.urls.next);
      }
      assertItemRendered('1');
      assertItemRendered('20');
      return fixtures.trigger(fakeEvent);
    });
  });

}).call(this);

(function() {
  define(['Backbone', 'compiled/collections/PaginatedCollection', 'helpers/getFakePage'], function(Backbone, PaginatedCollection, getFakePage) {
    module('PaginatedCollection', {
      setup: function() {
        this.server = sinon.fakeServer.create();
        this.collection = new PaginatedCollection(null, {
          params: {
            multi: ['foos', 'bars'],
            single: 1
          }
        });
        this.collection.url = '/test';
        this.collection.urlWithParams = function() {
          return this.url + '?' + $.param(this.options.params);
        };
        this.collection.model = Backbone.Model.extend();
        return this.server.sendPage = function(page, url) {
          return this.respond('GET', url, [
            200, {
              'Content-Type': 'application/json',
              'Link': page.header
            }, JSON.stringify(page.data)
          ]);
        };
      },
      teardown: function() {
        return this.server.restore();
      }
    });
    test('fetch maintains parent API', 6, function() {
      var dfd, page,
        _this = this;

      page = getFakePage();
      dfd = this.collection.fetch({
        success: function(self, response) {
          equal(self, _this.collection, 'passes itself into success handler');
          return deepEqual(response, page.data, 'passes response into success handler');
        }
      });
      ok(dfd.promise, 'returns a deferred object (quacks like a deferred)');
      dfd.done(function(data, status, xhr) {
        deepEqual(data, page.data, 'deferred is resolved with raw data');
        equal(status, 'success', 'text status is success');
        return ok(xhr.abort('function', 'jQuery xhr is passed in (quacks like a xhr)'));
      });
      return this.server.sendPage(page, this.collection.urlWithParams());
    });
    test('fetch maintains error handler API', 2, function() {
      var _this = this;

      this.collection.fetch({
        error: function(self, xhr) {
          equal(self, _this.collection, 'passes itself into fail handler');
          return deepEqual(xhr.responseText, 'wah wah', 'passes response into fail handler');
        }
      });
      return this.server.respond('GET', this.collection.urlWithParams(), [
        400, {
          'Content-Type': 'application/json'
        }, 'wah wah'
      ]);
    });
    test('fetch fires fetch event', 3, function() {
      var page,
        _this = this;

      page = getFakePage();
      this.collection.on('fetch', function(self, modelData) {
        ok(true, 'triggers fetch');
        deepEqual(modelData, page.data, 'passes data in');
        return equal(self, _this.collection, 'passes self in');
      });
      this.collection.fetch();
      return this.server.sendPage(page, this.collection.urlWithParams());
    });
    test('fetches current page', 10, function() {
      var page1,
        _this = this;

      page1 = getFakePage(1);
      this.collection.fetch({
        success: function() {
          equal(_this.collection.models.length, 2, 'added models to collection');
          equal(_this.collection.models[0].get('id'), 1, 'added model to collection');
          equal(_this.collection.models[1].get('id'), 2, 'added model to collection');
          return equal(_this.collection.urls.current, page1.urls.current, 'current url matches');
        }
      });
      this.server.sendPage(page1, this.collection.urlWithParams());
      this.collection.on('fetch:current', function(self, modelData) {
        ok(true, 'triggers fetch:current event');
        return deepEqual(modelData, page1.data, 'passes data in');
      });
      this.collection.fetch({
        page: 'current',
        success: function() {
          equal(_this.collection.models.length, 2, 'added models to collection');
          equal(_this.collection.models[0].get('id'), 1, 'passed in model to current page handler');
          equal(_this.collection.models[1].get('id'), 2, 'passed in model to current page handler');
          return equal(_this.collection.urls.current, page1.urls.current, 'current url matches');
        }
      });
      return this.server.sendPage(page1, this.collection.urls.current);
    });
    test('fetches next page', 8, function() {
      var page1, page2,
        _this = this;

      page1 = getFakePage(1);
      page2 = getFakePage(2);
      this.collection.fetch({
        success: function() {
          equal(_this.collection.models[0].get('id'), 1, 'added model to collection');
          equal(_this.collection.models[1].get('id'), 2, 'added model to collection');
          return equal(_this.collection.urls.next, page1.urls.next, 'next url matches');
        }
      });
      this.server.sendPage(page1, this.collection.urlWithParams());
      this.collection.on('fetch:next', function(self, modelData) {
        ok(true, 'triggers fetch:next event');
        return deepEqual(modelData, page2.data, 'passes data in');
      });
      this.collection.fetch({
        page: 'next',
        success: function() {
          equal(_this.collection.models[2].get('id'), 3, 'passed in model to next page handler');
          equal(_this.collection.models[3].get('id'), 4, 'passed in model to next page handler');
          return equal(_this.collection.urls.next, page2.urls.next, 'next url matches');
        }
      });
      return this.server.sendPage(page2, this.collection.urls.next);
    });
    test('fetches previous page', 8, function() {
      var page1, page2,
        _this = this;

      page1 = getFakePage(1);
      page2 = getFakePage(2);
      this.collection.fetch({
        success: function() {
          equal(_this.collection.models[0].get('id'), 3, 'added model to collection');
          equal(_this.collection.models[1].get('id'), 4, 'added model to collection');
          return equal(_this.collection.urls.prev, page2.urls.prev, 'prev url matches');
        }
      });
      this.server.sendPage(page2, this.collection.urlWithParams());
      this.collection.on('fetch:prev', function(self, modelData) {
        ok(true, 'triggers fetch:prev event');
        return deepEqual(modelData, page1.data, 'passes data in');
      });
      this.collection.fetch({
        page: 'prev',
        success: function() {
          equal(_this.collection.models[2].get('id'), 1, 'passed in model to prev page handler');
          equal(_this.collection.models[3].get('id'), 2, 'passed in model to prev page handler');
          return equal(_this.collection.urls.prev, void 0, 'prev url not set when there is not one');
        }
      });
      return this.server.sendPage(page1, this.collection.urls.prev);
    });
    return test('fetches current, prev, next, top and bottom pages', 8, function() {
      var page1, page2, page3, page4,
        _this = this;

      page1 = getFakePage(1);
      page2 = getFakePage(2);
      page3 = getFakePage(3);
      page4 = getFakePage(4);
      this.collection.fetch({
        success: function() {
          var expectedUrls;

          equal(_this.collection.models[0].get('id'), 5, 'added model to collection');
          expectedUrls = page3.urls;
          expectedUrls.top = page3.urls.prev;
          expectedUrls.bottom = page3.urls.next;
          return deepEqual(_this.collection.urls, expectedUrls, 'urls are as expected for fetch');
        }
      });
      this.server.sendPage(page3, this.collection.urlWithParams());
      this.collection.fetch({
        page: 'current',
        success: function() {
          var expectedUrls;

          expectedUrls = page3.urls;
          expectedUrls.top = page3.urls.prev;
          expectedUrls.bottom = page3.urls.next;
          return deepEqual(_this.collection.urls, expectedUrls, 'urls are as expected for fetch current');
        }
      });
      this.server.sendPage(page3, this.collection.urlWithParams());
      this.collection.fetch({
        page: 'prev',
        success: function() {
          var expectedUrls;

          equal(_this.collection.models.length, 4, 'added models to collection');
          expectedUrls = page2.urls;
          expectedUrls.top = page2.urls.prev;
          expectedUrls.bottom = page3.urls.next;
          return deepEqual(_this.collection.urls, expectedUrls, 'urls are as expected fetch prev');
        }
      });
      this.server.sendPage(page2, this.collection.urls.prev);
      this.collection.fetch({
        page: 'top',
        success: function() {
          var expectedUrls;

          equal(_this.collection.models.length, 6, 'added models to collection');
          expectedUrls = page1.urls;
          expectedUrls.bottom = page3.urls.next;
          return deepEqual(_this.collection.urls, expectedUrls, 'urls are as expected for fetch top');
        }
      });
      this.server.sendPage(page1, this.collection.urls.top);
      this.collection.fetch({
        page: 'bottom',
        success: function() {
          equal(_this.collection.models.length, 8, 'added models to collection');
          return equal(_this.collection.urls.bottom, page4.urls.next);
        }
      });
      return this.server.sendPage(page4, this.collection.urls.bottom);
    });
  });

}).call(this);

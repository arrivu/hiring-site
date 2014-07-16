(function() {
  define(['compiled/PaginatedList', 'helpers/loadFixture'], function(PaginatedList, loadFixture) {
    module('PaginatedList', {
      setup: function() {
        this.response = [
          200, {
            'Content-Type': 'application/json'
          }, '[{ "value": "one" }, { "value": "two" }]'
        ];
        this.template = function(opts) {
          var opt, tpl;

          tpl = function(opt) {
            return "<li>" + opt['value'] + "</li>";
          };
          return ((function() {
            var _i, _len, _results;

            _results = [];
            for (_i = 0, _len = opts.length; _i < _len; _i++) {
              opt = opts[_i];
              _results.push(tpl(opt));
            }
            return _results;
          })()).join('');
        };
        this.fixture = loadFixture('PaginatedList');
        this.el = {
          wrapper: $('#list-wrapper'),
          list: $('#list-wrapper').find('ul')
        };
        this.clock = sinon.useFakeTimers();
        return this.server = sinon.fakeServer.create();
      },
      teardown: function() {
        this.clock.restore();
        this.server.restore();
        return this.fixture.detach();
      }
    });
    test('should fetch and display results', function() {
      this.server.respondWith(/.+/, this.response);
      new PaginatedList(this.el.wrapper, {
        template: this.template,
        url: '/api/v1/test.json'
      });
      this.server.respond();
      this.clock.tick(500);
      return equal(this.el.list.children().length, 2);
    });
    test('should display a view more link if next page is available', function() {
      this.server.respondWith(/.+/, [
        this.response[0], {
          'Content-Type': 'application/json',
          'Link': 'rel="next"'
        }, this.response[2]
      ]);
      new PaginatedList(this.el.wrapper, {
        template: this.template,
        url: '/api/v1/test.json'
      });
      this.server.respond();
      this.clock.tick(500);
      return ok(this.el.wrapper.find('.view-more-link').length > 0);
    });
    test('should not display a view more link if there is no next page', function() {
      this.server.respondWith(/.+/, this.response);
      new PaginatedList(this.el.wrapper, {
        template: this.template,
        url: '/api/v1/test.json'
      });
      this.server.respond();
      this.clock.tick(500);
      return ok(this.el.wrapper.find('.view-more-link').length === 0);
    });
    test('should accept a template function', function() {
      this.server.respondWith(/.+/, this.response);
      new PaginatedList(this.el.wrapper, {
        template: this.template,
        url: '/api/v1/test.json'
      });
      this.server.respond();
      this.clock.tick(500);
      equal(this.el.list.find('li:first-child').text(), 'one');
      return equal(this.el.list.find('li:last-child').text(), 'two');
    });
    test('should accept a presenter function', function() {
      this.server.respondWith(/.+/, this.response);
      new PaginatedList(this.el.wrapper, {
        presenter: function(list) {
          var l, _i, _len, _results;

          _results = [];
          for (_i = 0, _len = list.length; _i < _len; _i++) {
            l = list[_i];
            _results.push({
              value: 'changed'
            });
          }
          return _results;
        },
        template: this.template,
        url: '/api/v1/test.json'
      });
      this.server.respond();
      this.clock.tick(500);
      return equal(this.el.list.find('li:first-child').text(), 'changed');
    });
    return test('should allow user to defer getJSON', function() {
      this.spy($, 'getJSON');
      new PaginatedList(this.el.wrapper, {
        start: false,
        template: this.template,
        url: '/api/v1/not-called.json'
      });
      return equal($.getJSON.callCount, 0);
    });
  });

}).call(this);

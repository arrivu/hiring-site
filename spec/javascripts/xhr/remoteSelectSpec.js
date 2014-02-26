(function() {
  define(['underscore', 'compiled/xhr/RemoteSelect'], function(_, RemoteSelect) {
    module('RemoteSelect', {
      setup: function() {
        this.response = [
          200, {
            'Content-Type': 'application/json'
          }, '[{ "label": "one", "value": 1 }, {"label": "two", "value": 2 }]'
        ];
        return this.el = $('<select id="test-select"></select>').appendTo('body');
      },
      teardown: function() {
        return this.el.remove();
      }
    });
    test('should load results into a select', function() {
      var rs, server;

      server = this.sandbox.useFakeServer();
      server.respondWith(/.+/, this.response);
      rs = new RemoteSelect(this.el, {
        url: '/test/url.json'
      });
      ok(this.el.prop('disabled'));
      server.respond();
      equal(this.el.children().length, 2);
      return server.restore();
    });
    test('should load an object as <optgroup>', function() {
      var rs, server;

      this.response.pop();
      this.response.push(JSON.stringify({
        'Group One': [
          {
            label: 'One',
            value: 1
          }, {
            label: 'Two',
            value: 2
          }
        ],
        'Group Two': [
          {
            label: 'Three',
            value: 3
          }, {
            label: 'Four',
            value: 4
          }
        ]
      }));
      server = this.sandbox.useFakeServer();
      server.respondWith(/.+/, this.response);
      rs = new RemoteSelect(this.el, {
        url: '/test/url.json'
      });
      server.respond();
      equal(this.el.children('optgroup').length, 2);
      equal(this.el.find('option').length, 4);
      return server.restore();
    });
    test('should cache responses', function() {
      var rs, server;

      server = this.sandbox.useFakeServer();
      server.respondWith(/.+/, this.response);
      this.spy($, 'getJSON');
      rs = new RemoteSelect(this.el, {
        url: '/test/cached.json'
      });
      server.respond();
      ok($.getJSON.calledOnce);
      equal(_.keys(rs.cache.store).length, 1);
      return server.restore();
    });
    test('should accept a formatter', function() {
      var format, rs, server;

      server = this.sandbox.useFakeServer();
      this.response.pop();
      this.response.push(JSON.stringify([
        {
          group: 'one',
          name: 'one',
          id: 1
        }, {
          group: 'one',
          name: 'two',
          id: 2
        }, {
          group: 'two',
          name: 'three',
          id: 3
        }, {
          group: 'two',
          name: 'four',
          id: 4
        }
      ]));
      server.respondWith(/.+/, this.response);
      format = function(data) {
        var groups;

        groups = _.groupBy(data, function(obj) {
          return obj.group;
        });
        _.each(groups, function(group, key) {
          return groups[key] = _.map(group, function(item) {
            return {
              label: item.name,
              value: item.id
            };
          });
        });
        return groups;
      };
      rs = new RemoteSelect(this.el, {
        formatter: format,
        url: '/test/url.json'
      });
      server.respond();
      equal(this.el.children('optgroup').length, 2);
      equal(this.el.find('option').length, 4);
      return server.restore();
    });
    test('should take params', function() {
      var rs, server;

      server = this.sandbox.useFakeServer();
      this.spy($, 'getJSON');
      rs = new RemoteSelect(this.el, {
        url: '/test/url.json',
        requestParams: {
          param: 'value'
        }
      });
      ok($.getJSON.calledWith('/test/url.json', {
        param: 'value'
      }, rs.onResponse));
      rs.spinner.remove();
      return server.restore();
    });
    return test('should include original options in select', function() {
      var rs, server;

      server = this.sandbox.useFakeServer();
      server.respondWith(/.+/, this.response);
      this.el.append('<option value="">Default</option>');
      rs = new RemoteSelect(this.el, {
        url: '/test/url.json'
      });
      server.respond();
      equal(this.el.children().length, 3);
      return server.restore();
    });
  });

}).call(this);

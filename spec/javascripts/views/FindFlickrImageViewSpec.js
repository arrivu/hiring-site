(function() {
  define(['Backbone', 'jquery', 'compiled/views/FindFlickrImageView', 'helpers/jquery.simulate'], function(Backbone, $, FindFlickrImageView) {
    var photoData, searchTerm, setupServerResponses;

    searchTerm = 'bunnies';
    photoData = [
      {
        id: "noooooo",
        secret: "whyyyyy",
        farm: "moooo",
        owner: "notyou",
        server: "maneframe"
      }, {
        id: "nooope",
        secret: "sobbbbb",
        farm: "sadface",
        owner: "meeee",
        server: "mwhahahah"
      }
    ];
    setupServerResponses = function() {
      var server;

      server = sinon.fakeServer.create();
      server.respondWith(/\/mock_flickr\/(.*)/, function(request) {
        var response;

        response = {
          photos: {
            photo: photoData
          }
        };
        if (request.url.indexOf(searchTerm) !== -1) {
          return request.respond(200, {
            'Content-Type': 'application/json'
          }, JSON.stringify(response));
        }
      });
      return server;
    };
    module('FindFlickrImage', {
      setup: function() {
        var $fixtures, view;

        this.server = setupServerResponses();
        $fixtures = $('#fixtures');
        view = new FindFlickrImageView;
        view.flickrUrl = '/mock_flickr';
        view.render().$el.appendTo($fixtures);
        return this.form = $('form.FindFlickrImageView').first();
      },
      teardown: function() {
        this.form.remove();
        return this.server.restore();
      }
    });
    test('render', function() {
      var button, input;

      expect(6);
      ok(this.form.length, 'flickr - form added to dom');
      ok(this.form.is(':visible'), 'flickr - form is visible');
      input = $('input.flickrSearchTerm', this.form);
      ok(input.length, 'flickr - search bar is added');
      ok(input.is(':visible'), 'flickr - search bar is visible');
      button = $('button[type=submit]', this.form);
      ok(button.length, 'flickr - submit button is added');
      return ok(button.is(':visible'), 'flickr - submit button form is visible');
    });
    return test('search', function() {
      var button, idx, input, results, _i, _results;

      expect(13);
      input = $('input.flickrSearchTerm', this.form);
      button = $('button[type=submit]', this.form);
      input.val(searchTerm);
      $('button[type=submit]', this.form).simulate('click');
      this.server.respond();
      results = $('ul.flickrResults li a.thumbnail', this.form);
      equal(results.length, 2, 'images are added to the results');
      _results = [];
      for (idx = _i = 0; _i <= 1; idx = ++_i) {
        ok(results.eq(idx).attr('data-fullsize').indexOf(photoData[idx].id) !== -1, 'flickr - img src has id');
        ok(results.eq(idx).attr('data-fullsize').indexOf(photoData[idx].secret) !== -1, 'flickr - img src has secret');
        ok(results.eq(idx).attr('data-fullsize').indexOf(photoData[idx].farm) !== -1, 'flickr - img src has farm');
        ok(results.eq(idx).attr('data-fullsize').indexOf(photoData[idx].server) !== -1, 'flickr - img src has server');
        ok(results.eq(idx).attr('data-linkto').indexOf(photoData[idx].id) !== -1, 'flickr - link has id');
        _results.push(ok(results.eq(idx).attr('data-linkto').indexOf(photoData[idx].owner) !== -1, 'flickr - link has owner'));
      }
      return _results;
    });
  });

}).call(this);

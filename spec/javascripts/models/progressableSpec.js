(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['compiled/models/progressable', 'Backbone'], function(progressable, _arg) {
    var Model, QuizCSV, clock, model, progressUrl, server, _ref;

    Model = _arg.Model;
    progressUrl = '/progress';
    server = null;
    clock = null;
    model = null;
    QuizCSV = (function(_super) {
      __extends(QuizCSV, _super);

      function QuizCSV() {
        _ref = QuizCSV.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      QuizCSV.mixin(progressable);

      return QuizCSV;

    })(Model);
    module('progressable', {
      setup: function() {
        clock = sinon.useFakeTimers();
        model = new QuizCSV;
        model.url = '/quiz_csv';
        server = sinon.fakeServer.create();
        server.respondWith('GET', progressUrl, [
          200, {
            "Content-Type": "application/json"
          }, '{"workflow_state": "completed"}'
        ]);
        return server.respondWith('GET', model.url, [
          200, {
            "Content-Type": "application/json"
          }, '{"csv": "one,two,three"}'
        ]);
      },
      teardown: function() {
        server.restore();
        return clock.restore();
      }
    });
    test('set progress_url', function() {
      var spy;

      spy = sinon.spy();
      model.progressModel.on('complete', spy);
      model.on('progressResolved', spy);
      model.set({
        progress_url: progressUrl
      });
      server.respond();
      server.respond();
      ok(spy.calledTwice, 'complete and progressResolved handlers called');
      equal(model.progressModel.get('workflow_state'), 'completed');
      return equal(model.get('csv'), 'one,two,three');
    });
    return test('set progress.url', function() {
      var spy;

      spy = sinon.spy();
      model.progressModel.on('complete', spy);
      model.on('progressResolved', spy);
      model.progressModel.set({
        url: progressUrl,
        workflow_state: 'queued'
      });
      server.respond();
      ok(spy.calledTwice, 'complete and progressResolved handlers called');
      server.respond();
      server.respond();
      equal(model.progressModel.get('workflow_state'), 'completed');
      return equal(model.get('csv'), 'one,two,three');
    });
  });

}).call(this);

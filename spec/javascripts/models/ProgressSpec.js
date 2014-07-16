(function() {
  define(['compiled/models/Progress'], function(Progress) {
    var clock, model, respond, server;

    server = null;
    clock = null;
    model = null;
    module('progressable', {
      setup: function() {
        server = sinon.fakeServer.create();
        clock = sinon.useFakeTimers();
        model = new Progress;
        return model.url = function() {
          return '/steve/' + new Date().getTime();
        };
      },
      teardown: function() {
        server.restore();
        return clock.restore();
      }
    });
    respond = function(data) {
      return server.respond("GET", model.url(), [
        200, {
          "Content-Type": "application/json"
        }, JSON.stringify(data)
      ]);
    };
    return test('polls the progress api until the job is finished', function() {
      var spy;

      spy = sinon.spy();
      model.on('complete', spy);
      model.poll();
      respond({
        workflow_state: 'queued'
      });
      equal(model.get('workflow_state'), 'queued');
      clock.tick(1000);
      respond({
        workflow_state: 'running'
      });
      equal(model.get('workflow_state'), 'running');
      clock.tick(1000);
      respond({
        workflow_state: 'completed'
      });
      equal(model.get('workflow_state'), 'completed');
      return ok(spy.calledOnce);
    });
  });

}).call(this);

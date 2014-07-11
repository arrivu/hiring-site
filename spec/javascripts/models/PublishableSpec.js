(function() {
  define(['compiled/models/Publishable'], function(Publishable) {
    var buildModule;

    buildModule = function(published) {
      return new Publishable({
        published: published
      }, {
        url: '/api/1/2/3'
      });
    };
    module('Publishable:', {
      setup: function() {},
      teardown: function() {}
    });
    test('publish updates the state of the model', function() {
      var cModule;

      cModule = buildModule(false);
      cModule.save = function() {};
      cModule.publish();
      return equal(cModule.get('published'), true);
    });
    test('publish saves to the server', function() {
      var cModule, saveStub;

      cModule = buildModule(true);
      saveStub = sinon.stub(cModule, 'save');
      cModule.publish();
      return ok(saveStub.calledOnce);
    });
    test('unpublish updates the state of the model', function() {
      var cModule;

      cModule = buildModule(true);
      cModule.save = function() {};
      cModule.unpublish();
      return equal(cModule.get('published'), false);
    });
    test('unpublish saves to the server', function() {
      var cModule, saveStub;

      cModule = buildModule(true);
      saveStub = sinon.stub(cModule, 'save');
      cModule.unpublish();
      return ok(saveStub.calledOnce);
    });
    return test('toJSON wraps attributes', function() {
      var publishable;

      publishable = new Publishable({
        published: true
      }, {
        root: 'module'
      });
      return equal(publishable.toJSON()['module']['published'], true);
    });
  });

}).call(this);

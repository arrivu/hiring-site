(function() {
  define(['Backbone', 'compiled/models/Module', 'compiled/collections/ModuleItemCollection'], function(Backbone, Module, ModuleItemCollection) {
    module('Module', {
      setup: function() {
        return this.server = sinon.fakeServer.create();
      },
      teardown: function() {
        return this.server.restore();
      }
    });
    test('should build an itemCollection from items', 2, function() {
      var mod;

      mod = new Module({
        id: 3,
        course_id: 4,
        items: [
          {
            id: 1
          }, {
            id: 2
          }
        ]
      });
      ok(mod.itemCollection instanceof ModuleItemCollection, "itemCollection is not built");
      return equal(mod.itemCollection.length, 2, "incorrect item length");
    });
    return test('should build an itemCollection and fetch if items are not passed', 1, function() {
      var mod;

      mod = new Module({
        id: 3,
        course_id: 4
      });
      ok(mod.itemCollection instanceof ModuleItemCollection, "itemCollection is not built");
      mod.itemCollection.fetch({
        success: function() {
          return equal(mod.itemCollection.length, 1, "incorrect item length");
        }
      });
      return this.server.respond('GET', mod.itemCollection.url(), [
        200, {
          'Content-Type': 'application/json'
        }, JSON.stringify({
          id: 2
        })
      ]);
    });
  });

}).call(this);

(function() {
  define(['compiled/collections/GroupUserCollection', 'Backbone'], function(GroupUserCollection, _arg) {
    var Model, source, target, users;

    Model = _arg.Model;
    source = null;
    target = null;
    users = null;
    module('GroupUserCollection', {
      setup: function() {
        users = [
          new Model({
            id: 1,
            name: "bob",
            sortable_name: "bob",
            groupId: null
          }), new Model({
            id: 2,
            name: "joe",
            sortable_name: "joe",
            groupId: null
          })
        ];
        source = new GroupUserCollection(users, {
          groupId: null
        });
        return target = new GroupUserCollection([], {
          groupId: 1
        });
      },
      teardown: function() {
        return GroupUserCollection.collectionMap = {};
      }
    });
    test("moves user to target group's collection when groupId changes", function() {
      users[0].set('groupId', 1);
      equal(source.length, 1);
      return equal(target.length, 1);
    });
    return test("removes user when target group's collection is not yet loaded", function() {
      users[0].set('groupId', 2);
      equal(source.length, 1);
      return equal(target.length, 0);
    });
  });

}).call(this);

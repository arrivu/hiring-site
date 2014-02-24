(function() {
  define(['Backbone', 'compiled/models/GroupUser', 'jquery'], function(Backbone, GroupUser, $) {
    module('GroupUser', {
      setup: function() {
        this.groupUser = new GroupUser();
        this.leavePreviousGroupStub = sinon.stub(this.groupUser, 'leavePreviousGroup');
        return this.joinGroupStub = sinon.stub(this.groupUser, 'joinGroup');
      },
      teardown: function() {
        this.leavePreviousGroupStub.restore();
        return this.joinGroupStub.restore();
      }
    });
    return test("updates groupId correctly upon save and fires joinGroup and leavePreviousGroup appropriately", function() {
      this.groupUser.save({
        'groupId': 777
      });
      equal(this.groupUser.get('groupId'), 777);
      equal(this.groupUser.get('previousGroupId'), null);
      equal(this.joinGroupStub.callCount, 1);
      ok(this.joinGroupStub.calledWith(777));
      equal(this.leavePreviousGroupStub.callCount, 0);
      this.groupUser.save({
        'groupId': 123
      });
      equal(this.groupUser.get('groupId'), 123);
      equal(this.groupUser.get('previousGroupId'), 777);
      equal(this.joinGroupStub.callCount, 2);
      ok(this.joinGroupStub.calledWith(123));
      this.groupUser.save({
        'groupId': null
      });
      equal(this.groupUser.get('groupId'), null);
      equal(this.groupUser.get('previousGroupId'), 123);
      equal(this.joinGroupStub.callCount, 2);
      return equal(this.leavePreviousGroupStub.callCount, 1);
    });
  });

}).call(this);

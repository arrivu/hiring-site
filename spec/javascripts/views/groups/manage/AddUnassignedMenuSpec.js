(function() {
  define(['compiled/collections/GroupCategoryUserCollection', 'compiled/models/GroupUser', 'compiled/views/groups/manage/AddUnassignedMenu', 'jquery'], function(GroupCategoryUserCollection, GroupUser, AddUnassignedMenu, $) {
    var clock, sendResponse, server, users, view, waldo;

    clock = null;
    server = null;
    waldo = null;
    users = null;
    view = null;
    sendResponse = function(method, url, json) {
      return server.respond(method, url, [
        200, {
          'Content-Type': 'application/json'
        }, JSON.stringify(json)
      ]);
    };
    module('AddUnassignedMenu', {
      setup: function() {
        clock = sinon.useFakeTimers();
        server = sinon.fakeServer.create();
        waldo = new GroupUser({
          id: 4,
          name: "Waldo",
          sortable_name: "Waldo"
        });
        users = new GroupCategoryUserCollection;
        users.setParam('search_term', 'term');
        view = new AddUnassignedMenu({
          collection: users
        });
        view.groupId = 777;
        users.reset([
          new GroupUser({
            id: 1,
            name: "Frank Herbert",
            sortable_name: "Herbert, Frank"
          }), new GroupUser({
            id: 2,
            name: "Neal Stephenson",
            sortable_name: "Stephenson, Neal"
          }), new GroupUser({
            id: 3,
            name: "John Scalzi",
            sortable_name: "Scalzi, John"
          }), waldo
        ]);
        return view.$el.appendTo($(document.body));
      },
      teardown: function() {
        clock.restore();
        server.restore();
        return view.remove();
      }
    });
    return test("updates the user's groupId and removes from unassigned collection", function() {
      var $links, $waldoLink;

      equal(waldo.get('groupId'), null);
      $links = view.$('.assign-user-to-group');
      equal($links.length, 4);
      $waldoLink = $links.last();
      $waldoLink.click();
      sendResponse('POST', waldo.createMembershipUrl(777), {});
      equal(waldo.get('groupId'), 777);
      return ok(!users.contains(waldo));
    });
  });

}).call(this);

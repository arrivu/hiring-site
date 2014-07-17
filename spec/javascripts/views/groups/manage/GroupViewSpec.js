(function() {
  define(['jquery', 'compiled/views/groups/manage/GroupView', 'compiled/views/groups/manage/GroupUsersView', 'compiled/collections/GroupCollection', 'compiled/collections/GroupUserCollection', 'compiled/models/Group', 'helpers/fakeENV'], function($, GroupView, GroupUsersView, GroupCollection, GroupUserCollection, Group) {
    var assertContracted, assertExpanded, group, users, view;

    view = null;
    group = null;
    users = null;
    module('GroupView', {
      setup: function() {
        var groupUsersView;

        group = new Group({
          id: 42,
          name: 'Foo Group',
          members_count: 7
        });
        users = new GroupUserCollection([
          {
            id: 1,
            name: "bob",
            sortable_name: "bob"
          }, {
            id: 2,
            name: "joe",
            sortable_name: "joe"
          }
        ]);
        users.loaded = true;
        users.loadedAll = true;
        group.users = function() {
          return users;
        };
        groupUsersView = new GroupUsersView({
          group: group,
          collection: users
        });
        view = new GroupView({
          groupUsersView: groupUsersView,
          model: group
        });
        view.render();
        return view.$el.appendTo($(document.body));
      },
      teardown: function() {
        return view.remove();
      }
    });
    assertContracted = function(view) {
      ok(view.$el.hasClass('group-collapsed'), 'expand visible');
      return ok(!view.$el.hasClass('group-expanded'), 'contract hidden');
    };
    assertExpanded = function(view) {
      ok(!view.$el.hasClass('group-collapsed'), 'expand hidden');
      return ok(view.$el.hasClass('group-expanded'), 'contract visible');
    };
    test('initial state should be contracted', function() {
      return assertContracted(view);
    });
    test('expand/contract buttons', function() {
      view.$('.toggle-group').eq(0).click();
      assertExpanded(view);
      view.$('.toggle-group').eq(0).click();
      return assertContracted(view);
    });
    test('renders groupUsers', function() {
      return ok(view.$('.group-user').length);
    });
    test('removes the group after successful deletion', function() {
      var confirmStub, server, url;

      url = "/api/v1/groups/" + (view.model.get('id'));
      server = sinon.fakeServer.create();
      server.respondWith(url, [
        200, {
          'Content-Type': 'application/json'
        }, JSON.stringify({})
      ]);
      confirmStub = sinon.stub(window, 'confirm');
      confirmStub.returns(true);
      view.$('.delete-group').click();
      server.respond();
      ok(!view.$el.hasClass('hidden'), 'group hidden');
      server.restore();
      return confirmStub.restore();
    });
    return test('editing group should change name', function() {
      var new_name, server, url;

      url = "/api/v1/groups/" + (view.model.get('id'));
      new_name = 'Newly changed name';
      server = sinon.fakeServer.create();
      server.respondWith(url, [
        200, {
          'Content-Type': 'application/json'
        }, JSON.stringify({
          id: 42,
          name: new_name
        })
      ]);
      view.$('.edit-group').click();
      equal($('#group_category_name').val(), group.get('name'));
      $('#group_category_name').val(new_name);
      $(".group-edit-dialog button[type=submit]").click();
      server.respond();
      return equal(group.get('name'), new_name);
    });
  });

}).call(this);

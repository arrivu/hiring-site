(function() {
  define(['compiled/views/courses/roster/CreateUsersView', 'compiled/collections/RolesCollection', 'compiled/models/Role', 'compiled/models/CreateUserList', 'helpers/assertions'], function(CreateUsersView, RolesCollection, Role, CreateUserList, assert) {
    var addUserText, assertEnrolledUsers, assertStepVisible, assertTextareaValue, assertVerifiedUsers, goToStep2, goToStep3, server, startOver, startOverFrd, view;

    view = null;
    server = null;
    module('CreateUsersView', {
      setup: function() {
        var attributes, roles;

        server = sinon.fakeServer.create();
        server.respondWith("POST", "/read", [
          200, {
            "Content-Type": "application/json"
          }, JSON.stringify({
            users: [
              {
                address: 'joe@joe.com',
                name: null,
                type: 'email'
              }
            ],
            errored_users: [],
            duplicates: []
          })
        ]);
        server.respondWith("POST", "/update", [
          200, {
            "Content-Type": "application/json"
          }, JSON.stringify([
            {
              enrollment: {
                name: 'joe@joe.com',
                email: 'joe@joe.com',
                section: 'MWF'
              }
            }
          ])
        ]);
        roles = [
          {
            label: 'Teacher',
            name: 'TeacherEnrollment',
            manageable_by_user: true
          }, {
            label: 'Student',
            name: 'StudentEnrollment',
            manageable_by_user: true
          }, {
            label: 'Fake',
            name: 'Fake',
            manageable_by_user: false
          }
        ];
        view = new CreateUsersView({
          trigger: false,
          title: 'test',
          rolesCollection: new RolesCollection((function() {
            var _i, _len, _results;

            _results = [];
            for (_i = 0, _len = roles.length; _i < _len; _i++) {
              attributes = roles[_i];
              _results.push(new Role(attributes));
            }
            return _results;
          })()),
          model: new CreateUserList({
            sections: [
              {
                id: 1,
                name: 'MWF'
              }, {
                id: 2,
                name: 'TTh'
              }
            ],
            roles: roles,
            readURL: '/read',
            updateURL: '/update'
          })
        });
        $('#fixtures').append(view.$el);
        return view.open();
      },
      teardown: function() {
        server.restore();
        return view.remove();
      }
    });
    addUserText = function() {
      return view.$textarea.val("joe@joe.com");
    };
    goToStep2 = function() {
      $('#next-step').click();
      return server.respond();
    };
    goToStep3 = function() {
      $('#createUsersAddButton').click();
      return server.respond();
    };
    assertVerifiedUsers = function() {
      return ok($('#create-users-verified').html().match('joe@joe.com'), 'verified users matched');
    };
    assertEnrolledUsers = function() {
      return ok($('#create-users-results').html().match('joe@joe.com'), 'enrolled users matched');
    };
    assertStepVisible = function(step) {
      return assert.isVisible($("#create-users-step-" + step));
    };
    startOver = function() {
      return view.$('.createUsersStartOver').click();
    };
    startOverFrd = function() {
      return view.$('.createUsersStartOverFrd').click();
    };
    assertTextareaValue = function(text) {
      return equal(view.$textarea.val(), text, 'textarea matches text');
    };
    test('moves through the steps', function() {
      assertStepVisible(1);
      addUserText();
      goToStep2();
      assertStepVisible(2);
      assertVerifiedUsers();
      goToStep3();
      assertStepVisible(3);
      assertEnrolledUsers();
      return view.close();
    });
    test('starts over on step 2', function() {
      addUserText();
      goToStep2();
      assertStepVisible(2);
      startOver();
      assertStepVisible(1);
      assertTextareaValue('joe@joe.com');
      return view.close();
    });
    test('starts over on step 3', function() {
      addUserText();
      goToStep2();
      goToStep3();
      assertStepVisible(3);
      startOverFrd();
      assertStepVisible(1);
      return assertTextareaValue('');
    });
    return test('resets data on close and reopen', function() {
      addUserText();
      assertTextareaValue('joe@joe.com');
      view.close();
      view.open();
      return assertTextareaValue('');
    });
  });

}).call(this);

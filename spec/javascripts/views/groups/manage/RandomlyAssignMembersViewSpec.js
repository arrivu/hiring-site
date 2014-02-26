(function() {
  define(['compiled/views/groups/manage/GroupCategoryView', 'compiled/views/groups/manage/RandomlyAssignMembersView', 'compiled/models/GroupCategory'], function(GroupCategoryView, RandomlyAssignMembersView, GroupCategory) {
    var assignUnassignedMembersResponse, globalObj, groupCategoryResponse, groupsResponse, model, progressResponse, sendResponse, server, unassignedUsersResponse, view;

    server = null;
    view = null;
    model = null;
    globalObj = this;
    sendResponse = function(method, url, json) {
      return server.respond({
        "cascade": false
      }, method, url, [
        200, {
          'Content-Type': 'application/json'
        }, JSON.stringify(json)
      ]);
    };
    groupsResponse = [
      {
        "description": null,
        "group_category_id": 20,
        "id": 61,
        "is_public": false,
        "join_level": "invitation_only",
        "name": "Ninjas",
        "members_count": 14,
        "storage_quota_mb": 50,
        "context_type": "Course",
        "course_id": 1,
        "followed_by_user": false,
        "avatar_url": null,
        "role": null
      }, {
        "description": null,
        "group_category_id": 20,
        "id": 62,
        "is_public": false,
        "join_level": "invitation_only",
        "name": "Samurai",
        "members_count": 14,
        "storage_quota_mb": 50,
        "context_type": "Course",
        "course_id": 1,
        "followed_by_user": false,
        "avatar_url": null,
        "role": null
      }, {
        "description": null,
        "group_category_id": 20,
        "id": 395,
        "is_public": false,
        "join_level": "invitation_only",
        "name": "Pirates",
        "members_count": 12,
        "storage_quota_mb": 50,
        "context_type": "Course",
        "course_id": 1,
        "followed_by_user": false,
        "avatar_url": null,
        "role": null
      }
    ];
    unassignedUsersResponse = [
      {
        "id": 41,
        "name": "Panda Farmer",
        "sortable_name": "Farmer, Panda",
        "short_name": "Panda Farmer",
        "sis_user_id": "337733",
        "sis_login_id": "pandafarmer134123@gmail.com",
        "login_id": "pandafarmer134123@gmail.com"
      }, {
        "id": 45,
        "name": "Elmer Fudd",
        "sortable_name": "Fudd, Elmer",
        "short_name": "Elmer Fudd",
        "login_id": "elmerfudd"
      }, {
        "id": 2,
        "name": "Leeroy Jenkins",
        "sortable_name": "Jenkins, Leeroy",
        "short_name": "Leeroy Jenkins"
      }
    ];
    assignUnassignedMembersResponse = {
      "completion": 0,
      "context_id": 20,
      "context_type": "GroupCategory",
      "created_at": "2013-07-17T11:05:38-06:00",
      "id": 105,
      "message": null,
      "tag": "assign_unassigned_members",
      "updated_at": "2013-07-17T11:05:38-06:00",
      "user_id": null,
      "workflow_state": "running",
      "url": "http://localhost:3000/api/v1/progress/105"
    };
    progressResponse = {
      "completion": 100,
      "context_id": 20,
      "context_type": "GroupCategory",
      "created_at": "2013-07-17T11:05:38-06:00",
      "id": 105,
      "message": null,
      "tag": "assign_unassigned_members",
      "updated_at": "2013-07-17T11:05:44-06:00",
      "user_id": null,
      "workflow_state": "completed",
      "url": "http://localhost:3000/api/v1/progress/105"
    };
    groupCategoryResponse = {
      "id": 20,
      "name": "Gladiators",
      "role": null,
      "self_signup": "enabled",
      "context_type": "Course",
      "course_id": 1
    };
    module('RandomlyAssignMembersView', {
      setup: function() {
        server = sinon.fakeServer.create();
        this._ENV = globalObj.ENV;
        globalObj.ENV = {
          group_user_type: 'student',
          IS_LARGE_ROSTER: false
        };
        model = new GroupCategory({
          id: 20,
          name: "Project Group"
        });
        view = new GroupCategoryView({
          model: model
        });
        server.respondWith("GET", "/api/v1/group_categories/20/groups?per_page=50", [
          200, {
            "Content-Type": "application/json"
          }, JSON.stringify(groupsResponse)
        ]);
        server.respondWith("GET", "/api/v1/group_categories/20/users?unassigned=true&per_page=50", [
          200, {
            "Content-Type": "application/json"
          }, JSON.stringify(unassignedUsersResponse)
        ]);
        view.render();
        view.$el.appendTo($(document.body));
        server.respond();
        return server.responses = [];
      },
      teardown: function() {
        server.restore();
        globalObj.ENV = this._ENV;
        return view.remove();
      }
    });
    return test('randomly assigns unassigned users', function() {
      var $assignOptionLink, $cog, $confirmAssignButton, $groups, $progressContainer;

      $progressContainer = $('.progress-container');
      $groups = $('[data-view=groups]');
      equal($progressContainer.length, 0, "Progress bar hidden by default");
      equal($groups.length, 1, "Groups shown by default");
      equal(model.unassignedUsers().length, 3, "There are unassigned users to begin with");
      $cog = $('.icon-mini-arrow-down');
      $cog.click();
      $assignOptionLink = $('.randomly-assign-members');
      $assignOptionLink.click();
      $confirmAssignButton = $('.randomly-assign-members-confirm');
      $confirmAssignButton.click();
      sendResponse("POST", "/api/v1/group_categories/20/assign_unassigned_members", assignUnassignedMembersResponse);
      $progressContainer = $('.progress-container');
      $groups = $('[data-view=groups]');
      equal($progressContainer.length, 1, "Shows progress bar during assigning process");
      equal($groups.length, 0, "Hides groups during assigning process");
      sendResponse("GET", /progress/, progressResponse);
      sendResponse("GET", "/api/v1/group_categories/20", groupCategoryResponse);
      server.respondWith("GET", "/api/v1/group_categories/20/groups?per_page=50", [
        200, {
          "Content-Type": "application/json"
        }, JSON.stringify(groupsResponse)
      ]);
      server.respondWith("GET", "/api/v1/group_categories/20/users?unassigned=true&per_page=50", [
        200, {
          "Content-Type": "application/json"
        }, JSON.stringify([])
      ]);
      server.respond();
      $progressContainer = $('.progress-container');
      $groups = $('[data-view=groups]');
      equal($progressContainer.length, 0, "Hides progress bar after assigning process");
      equal($groups.length, 1, "Reveals groups after assigning process");
      return equal(model.unassignedUsers().length, 0, "There are no longer unassigned users");
    });
  });

}).call(this);

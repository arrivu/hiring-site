(function() {
  define(['Backbone', 'compiled/collections/AssignmentGroupCollection', 'compiled/models/AssignmentGroup', 'compiled/models/Assignment', 'compiled/views/assignments/AssignmentGroupListItemView', 'compiled/views/assignments/AssignmentListItemView', 'jquery', 'helpers/jquery.simulate', 'compiled/behaviors/elementToggler'], function(Backbone, AssignmentGroupCollection, AssignmentGroup, Assignment, AssignmentGroupListItemView, AssignmentListItemView, $) {
    var assignment1, assignment2, assignment3, buildAssignment, buildGroup, createAssignmentGroup, createView, fixtures, group1, group2;

    fixtures = $('#fixtures');
    assignment1 = function() {
      var date1, date2;

      date1 = {
        "due_at": "2013-08-28T23:59:00-06:00",
        "title": "Summer Session"
      };
      date2 = {
        "due_at": "2013-08-28T23:59:00-06:00",
        "title": "Winter Session"
      };
      return buildAssignment({
        "id": 1,
        "name": "History Quiz",
        "description": "test",
        "due_at": "2013-08-21T23:59:00-06:00",
        "points_possible": 2,
        "position": 1,
        "all_dates": [date1, date2]
      });
    };
    assignment2 = function() {
      return buildAssignment({
        "id": 3,
        "name": "Math Quiz",
        "due_at": "2013-08-23T23:59:00-06:00",
        "points_possible": 10,
        "position": 2
      });
    };
    assignment3 = function() {
      return buildAssignment({
        "id": 2,
        "name": "Science Quiz",
        "points_possible": 5,
        "position": 3
      });
    };
    buildAssignment = function(options) {
      var base;

      if (options == null) {
        options = {};
      }
      base = {
        "assignment_group_id": 1,
        "due_at": null,
        "grading_type": "points",
        "points_possible": 5,
        "position": 2,
        "course_id": 1,
        "name": "Science Quiz",
        "submission_types": [],
        "html_url": "http://localhost:3000/courses/1/assignments/" + options.id,
        "needs_grading_count": 0,
        "all_dates": [],
        "published": true
      };
      return $.extend(base, options);
    };
    group1 = function() {
      return buildGroup();
    };
    group2 = function() {
      return buildGroup({
        "id": 2,
        "name": "Other Assignments",
        "position": 2,
        "rules": {
          "drop_lowest": 1,
          "drop_highest": 2,
          "never_drop": [3, 4]
        }
      });
    };
    buildGroup = function(options) {
      var assignments, base;

      if (options == null) {
        options = {};
      }
      assignments = [assignment1(), assignment2(), assignment3()];
      base = {
        "id": 1,
        "name": "Assignments",
        "position": 1,
        "rules": {},
        "group_weight": 1,
        "assignments": assignments
      };
      return $.extend(base, options);
    };
    createAssignmentGroup = function(group) {
      var groups;

      if (group == null) {
        group = buildGroup();
      }
      groups = new AssignmentGroupCollection([group]);
      return groups.models[0];
    };
    createView = function(model, options) {
      var view;

      options = $.extend({
        canManage: true
      }, options);
      sinon.stub(AssignmentGroupListItemView.prototype, "canManage", function() {
        return options.canManage;
      });
      sinon.stub(AssignmentGroupListItemView.prototype, "currentUserId", function() {
        return 1;
      });
      sinon.stub(AssignmentListItemView.prototype, "canManage", function() {
        return options.canManage;
      });
      sinon.stub(AssignmentListItemView.prototype, "modules", function() {});
      view = new AssignmentGroupListItemView({
        model: model,
        course: new Backbone.Model({
          id: 1
        })
      });
      view.$el.appendTo($('#fixtures'));
      view.render();
      return view;
    };
    module('AssignmentGroupListItemView', {
      setup: function() {
        return this.model = createAssignmentGroup();
      },
      teardown: function() {
        AssignmentGroupListItemView.prototype.canManage.restore();
        AssignmentListItemView.prototype.canManage.restore();
        AssignmentListItemView.prototype.modules.restore();
        return AssignmentGroupListItemView.prototype.currentUserId.restore();
      }
    });
    test("initializes collection", function() {
      var view;

      view = createView(this.model);
      return ok(view.collection);
    });
    test("does not parse response with multiple due dates", function() {
      var a1, a2, models;

      models = this.model.get("assignments").models;
      a1 = models[0];
      a2 = models[1];
      sinon.spy(a1, 'doNotParse');
      sinon.spy(a2, 'doNotParse');
      createView(this.model);
      ok(a1.multipleDueDates());
      ok(a1.doNotParse.called);
      a1.doNotParse.restore();
      ok(!a2.multipleDueDates());
      ok(!a2.doNotParse.called);
      return a2.doNotParse.restore();
    });
    test("initializes child views if can manage", function() {
      var view;

      view = createView(this.model);
      ok(view.editGroupView);
      ok(view.createAssignmentView);
      return ok(view.deleteGroupView);
    });
    test("initializes no child views if can't manage", function() {
      var view;

      view = createView(this.model, {
        canManage: false
      });
      ok(!view.editGroupView);
      ok(!view.createAssignmentView);
      return ok(!view.deleteGroupView);
    });
    test("initializes cache", function() {
      var view;

      view = createView(this.model);
      return ok(view.cache);
    });
    test("toJSON includes group weight", function() {
      var json, view;

      view = createView(this.model);
      json = view.toJSON();
      return equal(json.groupWeight, 1);
    });
    test("shouldBeExpanded returnes cache state", function() {
      var view;

      view = createView(this.model);
      if (!view.shouldBeExpanded()) {
        view.toggleCache();
      }
      ok(view.shouldBeExpanded());
      view.toggleCache();
      return ok(!view.shouldBeExpanded());
    });
    test("currentlyExpanded returns expanded state", function() {
      var view;

      view = createView(this.model);
      if (!view.shouldBeExpanded()) {
        view.toggleCache();
      }
      return ok(view.currentlyExpanded());
    });
    test("toggleCollapse toggles expansion", function() {
      var view;

      view = createView(this.model);
      if (!view.shouldBeExpanded()) {
        view.toggleCache();
      }
      view.toggleCollapse();
      ok(!view.currentlyExpanded());
      view.toggleCollapse();
      return ok(view.currentlyExpanded());
    });
    test("displayableRules", function() {
      var model, view;

      model = createAssignmentGroup(group2());
      view = createView(model);
      return equal(view.displayableRules().length, 3);
    });
    return test("cacheKey builds unique key", function() {
      var view;

      view = createView(this.model);
      return deepEqual(view.cacheKey(), ["course", 1, "user", 1, "ag", 1, "expanded"]);
    });
  });

}).call(this);

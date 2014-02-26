(function() {
  define(['Backbone', 'compiled/collections/AssignmentGroupCollection', 'compiled/models/AssignmentGroup', 'compiled/models/Assignment', 'compiled/views/assignments/CreateAssignmentView', 'compiled/views/DialogFormView', 'jquery', 'helpers/jquery.simulate'], function(Backbone, AssignmentGroupCollection, AssignmentGroup, Assignment, CreateAssignmentView, DialogFormView, $) {
    var assignment1, assignment2, assignmentGroup, buildAssignment, buildAssignment1, buildAssignment2, createView, fixtures;

    fixtures = $('#fixtures');
    assignment1 = function() {
      return new Assignment(buildAssignment1());
    };
    assignment2 = function() {
      return new Assignment(buildAssignment2());
    };
    buildAssignment1 = function() {
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
    buildAssignment2 = function() {
      return buildAssignment({
        "id": 3,
        "name": "Math Quiz",
        "due_at": "2013-08-23T23:59:00-06:00",
        "points_possible": 10,
        "position": 2
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
    assignmentGroup = function() {
      var assignments, group, groups;

      assignments = [buildAssignment1(), buildAssignment2()];
      group = {
        "id": 1,
        "name": "Assignments",
        "position": 1,
        "rules": {},
        "group_weight": 1,
        "assignments": assignments
      };
      groups = new AssignmentGroupCollection([group]);
      return groups.models[0];
    };
    createView = function(model) {
      var opts, view;

      opts = model.constructor === AssignmentGroup ? {
        assignmentGroup: model
      } : {
        model: model
      };
      view = new CreateAssignmentView(opts);
      view.$el.appendTo($('#fixtures'));
      return view.render();
    };
    module('CreateAssignmentView', {
      setup: function() {
        this.assignment1 = assignment1();
        this.assignment2 = assignment2();
        return this.group = assignmentGroup();
      }
    });
    test("initialize generates a new assignment for creation", function() {
      var view;

      view = createView(this.group);
      return equal(view.model.get("assignment_group_id"), this.group.get("id"));
    });
    test("initialize uses existing assignment for editing", function() {
      var view;

      view = createView(this.assignment1);
      return equal(view.model.get("name"), this.assignment1.get("name"));
    });
    test("render shows multipleDueDates if we have all dates", function() {
      var view;

      view = createView(this.assignment1);
      return equal(view.$('.multiple_due_dates').length, 1);
    });
    test("render shows date picker when there are not multipleDueDates", function() {
      var view;

      view = createView(this.assignment2);
      return equal(view.$('.multiple_due_dates').length, 0);
    });
    test("render shows canChooseType for creation", function() {
      var view;

      view = createView(this.group);
      equal(view.$("#ag_1_assignment_type").length, 1);
      return equal(view.$("#assign_1_assignment_type").length, 0);
    });
    test("render hides canChooseType for editing", function() {
      var view;

      view = createView(this.assignment1);
      equal(view.$("#ag_1_assignment_type").length, 0);
      return equal(view.$("#assign_1_assignment_type").length, 0);
    });
    test("onSaveSuccess adds model to assignment group for creation", function() {
      var view;

      sinon.stub(DialogFormView.prototype, "close", function() {});
      equal(this.group.get("assignments").length, 2);
      view = createView(this.group);
      view.onSaveSuccess();
      equal(this.group.get("assignments").length, 3);
      return DialogFormView.prototype.close.restore();
    });
    test("moreOptions redirects to new page for creation", function() {
      var view;

      sinon.stub(CreateAssignmentView.prototype, "newAssignmentUrl", function() {});
      sinon.stub(CreateAssignmentView.prototype, "redirectTo", function() {});
      view = createView(this.group);
      view.moreOptions();
      ok(view.redirectTo.called);
      CreateAssignmentView.prototype.newAssignmentUrl.restore();
      return CreateAssignmentView.prototype.redirectTo.restore();
    });
    test("moreOptions redirects to edit page for editing", function() {
      var view;

      sinon.stub(CreateAssignmentView.prototype, "redirectTo", function() {});
      view = createView(this.assignment1);
      view.moreOptions();
      ok(view.redirectTo.called);
      return CreateAssignmentView.prototype.redirectTo.restore();
    });
    test("generateNewAssignment builds new assignment model", function() {
      var assign, view;

      view = createView(this.group);
      assign = view.generateNewAssignment();
      return ok(assign.constructor === Assignment);
    });
    test("toJSON creates unique label for creation", function() {
      var json, view;

      view = createView(this.group);
      json = view.toJSON();
      return equal(json.uniqLabel, "ag_1");
    });
    test("toJSON creates unique label for editing", function() {
      var json, view;

      view = createView(this.assignment1);
      json = view.toJSON();
      return equal(json.uniqLabel, "assign_1");
    });
    test("toJSON includes can choose type when creating", function() {
      var json, view;

      view = createView(this.group);
      json = view.toJSON();
      return ok(json.canChooseType);
    });
    test("toJSON includes cannot choose type when creating", function() {
      var json, view;

      view = createView(this.assignment1);
      json = view.toJSON();
      return ok(!json.canChooseType);
    });
    test("openAgain doesn't add datetime for multiple dates", function() {
      var view;

      sinon.stub(DialogFormView.prototype, "openAgain", function() {});
      sinon.spy($.fn, "datetime_field");
      view = createView(this.assignment1);
      view.openAgain();
      ok($.fn.datetime_field.notCalled);
      $.fn.datetime_field.restore();
      return DialogFormView.prototype.openAgain.restore();
    });
    return test("openAgain adds datetime picker", function() {
      var view;

      sinon.stub(DialogFormView.prototype, "openAgain", function() {});
      sinon.spy($.fn, "datetime_field");
      view = createView(this.assignment2);
      view.openAgain();
      ok($.fn.datetime_field.called);
      $.fn.datetime_field.restore();
      return DialogFormView.prototype.openAgain.restore();
    });
  });

}).call(this);

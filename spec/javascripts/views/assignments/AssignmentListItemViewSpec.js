(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['Backbone', 'compiled/models/Assignment', 'compiled/views/assignments/AssignmentListItemView', 'jquery', 'helpers/jquery.simulate'], function(Backbone, Assignment, AssignmentListItemView, $) {
    var AssignmentCollection, assignment1, assignment2, assignment3, buildAssignment, createView, fixtures, _ref;

    fixtures = $('#fixtures');
    AssignmentCollection = (function(_super) {
      __extends(AssignmentCollection, _super);

      function AssignmentCollection() {
        _ref = AssignmentCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      AssignmentCollection.prototype.model = Assignment;

      return AssignmentCollection;

    })(Backbone.Collection);
    assignment1 = function() {
      var ac, date1, date2;

      date1 = {
        "due_at": "2013-08-28T23:59:00-06:00",
        "title": "Summer Session"
      };
      date2 = {
        "due_at": "2013-08-28T23:59:00-06:00",
        "title": "Winter Session"
      };
      ac = new AssignmentCollection([
        buildAssignment({
          "id": 1,
          "name": "History Quiz",
          "description": "test",
          "due_at": "2013-08-21T23:59:00-06:00",
          "points_possible": 2,
          "position": 1,
          "all_dates": [date1, date2]
        })
      ]);
      return ac.at(0);
    };
    assignment2 = function() {
      var ac;

      ac = new AssignmentCollection([
        buildAssignment({
          "id": 3,
          "name": "Math Quiz",
          "due_at": "2013-08-23T23:59:00-06:00",
          "points_possible": 10,
          "position": 2
        })
      ]);
      return ac.at(0);
    };
    assignment3 = function() {
      var ac;

      ac = new AssignmentCollection([
        buildAssignment({
          "id": 2,
          "name": "Science Quiz",
          "points_possible": 5,
          "position": 3
        })
      ]);
      return ac.at(0);
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
    createView = function(model, options) {
      var view;

      options = $.extend({
        canManage: true
      }, options);
      sinon.stub(AssignmentListItemView.prototype, "canManage", function() {
        return options.canManage;
      });
      sinon.stub(AssignmentListItemView.prototype, "modules", function() {});
      view = new AssignmentListItemView({
        model: model
      });
      view.$el.appendTo($('#fixtures'));
      view.render();
      AssignmentListItemView.prototype.canManage.restore();
      AssignmentListItemView.prototype.modules.restore();
      return view;
    };
    module('AssignmentListItemViewSpec', {
      setup: function() {
        return this.model = assignment1();
      }
    });
    test("initializes child views if can manage", function() {
      var view;

      view = createView(this.model, {
        canManage: true
      });
      ok(view.publishIconView);
      ok(view.vddDueTooltipView);
      return ok(view.editAssignmentView);
    });
    test("initializes no child views if can't manage", function() {
      var view;

      view = createView(this.model, {
        canManage: false
      });
      ok(!view.publishIconView);
      ok(!view.vddTooltipView);
      return ok(!view.editAssignmentView);
    });
    test("upatePublishState toggles ig-published", function() {
      var view;

      view = createView(this.model);
      sinon.stub(AssignmentListItemView.prototype, "canManage", function() {
        return true;
      });
      sinon.stub(AssignmentListItemView.prototype, "modules", function() {});
      ok(view.$('.ig-row').hasClass('ig-published'));
      this.model.set('published', false);
      this.model.save;
      ok(!view.$('.ig-row').hasClass('ig-published'));
      AssignmentListItemView.prototype.canManage.restore();
      return AssignmentListItemView.prototype.modules.restore();
    });
    return test("delete destroys model", function() {
      var view;

      window.ENV = {
        context_asset_string: "course_1"
      };
      view = createView(this.model);
      sinon.spy(view.model, "destroy");
      view["delete"]();
      ok(view.model.destroy.called);
      return view.model.destroy.restore();
    });
  });

}).call(this);

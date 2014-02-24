(function() {
  define(['Backbone', 'compiled/models/AssignmentGroup', 'compiled/models/Assignment', 'compiled/models/Course', 'compiled/collections/AssignmentGroupCollection', 'compiled/views/assignments/AssignmentGroupListView', 'compiled/views/assignments/IndexView', 'jquery', 'helpers/jquery.simulate'], function(Backbone, AssignmentGroup, Assignment, Course, AssignmentGroupCollection, AssignmentGroupListView, IndexView, $) {
    var assignmentGroups, assignmentIndex, fixtures, oldENV;

    fixtures = $('#fixtures');
    assignmentGroups = null;
    assignmentIndex = function() {
      var app, assignmentGroupsView, course, group1, group2;

      $('<div id="content"></div>').appendTo(fixtures);
      course = new Course({
        id: 1
      });
      group1 = new AssignmentGroup({
        name: "Group 1",
        assignments: [
          {
            id: 1,
            name: 'Foo Name'
          }, {
            id: 2,
            name: 'Bar Title'
          }
        ]
      });
      group2 = new AssignmentGroup({
        name: "Group 2",
        assignments: [
          {
            id: 1,
            name: 'Baz Title'
          }, {
            id: 2,
            name: 'Qux Name'
          }
        ]
      });
      assignmentGroups = new AssignmentGroupCollection([group1, group2], {
        course: course
      });
      assignmentGroupsView = new AssignmentGroupListView({
        collection: assignmentGroups,
        course: course
      });
      app = new IndexView({
        assignmentGroupsView: assignmentGroupsView,
        collection: assignmentGroups,
        createGroupView: false,
        assignmentSettingsView: false,
        showByView: false
      });
      return app.render();
    };
    oldENV = null;
    module('assignmentIndex', {
      setup: function() {
        oldENV = window.ENV;
        window.ENV = {
          MODULES: {},
          PERMISSIONS: {
            manage: true
          }
        };
        return this.enable_spy = sinon.spy(IndexView.prototype, 'enableSearch');
      },
      teardown: function() {
        window.ENV = oldENV;
        assignmentGroups = null;
        return this.enable_spy.restore();
      }
    });
    test('should filter by search term', function() {
      var view;

      view = assignmentIndex();
      $('#search_term').val('foo');
      view.filterResults();
      equal(view.$el.find('.assignment:visible').length, 1);
      view = assignmentIndex();
      $('#search_term').val('BooBerry');
      view.filterResults();
      equal(view.$el.find('.assignment:visible').length, 0);
      view = assignmentIndex();
      $('#search_term').val('name');
      view.filterResults();
      return equal(view.$el.find('.assignment:visible').length, 2);
    });
    test('should have search disabled on render', function() {
      var view;

      view = assignmentIndex();
      return ok(view.$('#search_term').is(':disabled'));
    });
    test('should enable search on assignmentGroup reset', function() {
      var view;

      view = assignmentIndex();
      assignmentGroups.reset();
      return ok(!view.$('#search_term').is(':disabled'));
    });
    return test('enable search handler should only fire on the first reset', function() {
      var view;

      view = assignmentIndex();
      assignmentGroups.reset();
      ok(this.enable_spy.calledOnce);
      assignmentGroups.reset();
      return ok(this.enable_spy.calledOnce);
    });
  });

}).call(this);

(function() {
  define(['compiled/collections/AssignmentOverrideCollection', 'compiled/models/Assignment', 'compiled/collections/SectionCollection', 'compiled/models/DueDateList', 'compiled/views/assignments/DueDateView', 'Backbone', 'compiled/views/assignments/DueDateList', 'underscore'], function(AssignmentOverrideCollection, Assignment, SectionCollection, DueDateList, DueDateView, _arg, DueDateListView, _) {
    var View, stub;

    View = _arg.View;
    stub = sinon.stub;
    module("DueDateListView", {
      setup: function() {
        this.clock = sinon.useFakeTimers();
        this.assignment = new Assignment;
        this.overrides = new AssignmentOverrideCollection([
          {
            id: '1',
            course_section_id: '1'
          }, {
            id: '2',
            course_section_id: '2'
          }
        ]);
        this.sections = new SectionCollection([
          {
            id: '1',
            name: "foo"
          }, {
            id: '2',
            name: "bar"
          }, {
            id: '3',
            name: "baz"
          }
        ]);
        this.dueDateList = new DueDateList(this.overrides, this.sections);
        this.dueDateListView = new DueDateListView({
          model: this.dueDateList
        });
        return this.stubReRenderSections = function(stubAvailableSections) {
          if (stubAvailableSections == null) {
            stubAvailableSections = true;
          }
          return this.dueDateListView.dueDateViews.forEach(function(dueDateView) {
            return stub(dueDateView, 'reRenderSections');
          });
        };
      },
      teardown: function() {
        return this.clock.restore();
      }
    });
    test("creates child DueDateViews for each override", function() {
      return strictEqual(this.dueDateListView.dueDateViews.length, 2);
    });
    test("when a child duedate view emits model change event for course_section_id,\ntells each of its child views to re-render with a newly calculated list of\navailable sections", function() {
      var override,
        _this = this;

      override = this.overrides.get(2);
      this.stubReRenderSections();
      this.overrides.on('change:course_section_id', function(override) {
        return _this.dueDateListView.dueDateViews.forEach(function(dueDateView) {
          return strictEqual(dueDateView.reRenderSections.called, true, "sections not set!");
        });
      });
      this.clock.tick(1);
      return override.set('course_section_id', 3);
    });
    test("when override is removed views are told to re render with the freshly\ngenerated list of available sections", function() {
      var override,
        _this = this;

      this.stubReRenderSections();
      override = this.overrides.get(2);
      this.overrides.on('change:course_section_id', function(override) {
        return _this.dueDateListView.dueDateViews.forEach(function(dueDateView) {
          return strictEqual(dueDateView.reRenderSections.called, true);
        });
      });
      this.clock.tick(1);
      return override.set('course_section_id', 3);
    });
    return test("when override is added views are told to re render with the freshly\n  generated list of available sections", function() {
      var override,
        _this = this;

      this.stubReRenderSections();
      override = this.overrides.get(2);
      this.overrides.on('add', function(override) {
        strictEqual(_this.dueDateListView.dueDateViews.length, 3);
        _this.dueDateListView.dueDateViews.pop();
        return _this.dueDateListView.dueDateViews.forEach(function(dueDateView) {
          return strictEqual(dueDateView.reRenderSections.called, true);
        });
      });
      this.clock.tick(1);
      return this.overrides.add({
        id: 'foo',
        'course_section_id': '4'
      });
    });
  });

}).call(this);

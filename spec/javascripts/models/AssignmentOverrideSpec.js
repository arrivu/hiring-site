(function() {
  define(['compiled/models/AssignmentOverride', 'compiled/models/Assignment'], function(AssignmentOverride, Assignment) {
    module("AssignmentOverride", {
      setup: function() {
        return this.clock = sinon.useFakeTimers();
      },
      teardown: function() {
        return this.clock.restore();
      }
    });
    test("#representsDefaultDueDate returns true if course_section_id == 0", function() {
      var override;

      override = new AssignmentOverride({
        course_section_id: 0
      });
      return strictEqual(override.representsDefaultDueDate(), true);
    });
    test("#representsDefaultDueDate returns false if course_section_id != 0", function() {
      var override;

      override = new AssignmentOverride({
        course_section_id: 11
      });
      return strictEqual(override.representsDefaultDueDate(), false);
    });
    test("#AssignmentOverride.defaultDueDate class method returns an AssignmentOverride that represents the default due date", function() {
      var override;

      override = AssignmentOverride.defaultDueDate();
      return strictEqual(override.representsDefaultDueDate(), true);
    });
    return test("updates id to undefined if course_section_changes", function() {
      var override;

      override = new AssignmentOverride({
        id: 1,
        course_section_id: 1
      });
      override.set('course_section_id', 3);
      return strictEqual(override.toJSON().assignment_override.id, void 0);
    });
  });

}).call(this);

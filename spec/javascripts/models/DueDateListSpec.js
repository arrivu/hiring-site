(function() {
  define(['compiled/models/DueDateList', 'compiled/models/Assignment', 'compiled/models/AssignmentOverride', 'compiled/collections/AssignmentOverrideCollection', 'compiled/models/Section', 'compiled/collections/SectionCollection', 'underscore'], function(DueDateList, Assignment, AssignmentOverride, AssignmentOverrideCollection, Section, SectionList, _) {
    var stub;

    stub = sinon.stub;
    module("DueDateList", {
      setup: function() {
        this.date = Date.now();
        this.assignment = new Assignment({
          due_at: this.date,
          unlock_at: this.date,
          lock_at: this.date
        });
        this.overrides = new AssignmentOverrideCollection([
          new AssignmentOverride({
            course_section_id: '1'
          }), new AssignmentOverride({
            course_section_id: '2'
          })
        ]);
        this.sections = new SectionList([
          new Section({
            id: '1',
            name: "CourseSection1"
          }), new Section({
            id: '2',
            name: "CourseSection2"
          }), new Section({
            id: '3',
            name: "CourseSection3"
          })
        ]);
        return this.dueDateList = new DueDateList(this.overrides, this.sections);
      }
    });
    test("#availableSections returns list of course sections that\nare not being used by the AssignmentOverrideCollection", function() {
      var availableSections;

      availableSections = this.dueDateList.availableSections();
      strictEqual(availableSections.length, 1);
      return strictEqual(availableSections[0].id, '3');
    });
    test("#containsSectionsWithoutOverrides returns true when a section's id\ndoes not belong to an AssignmentOverride and there isn't an\noverride representing a default due date present", function() {
      return strictEqual(this.dueDateList.containsSectionsWithoutOverrides(), true);
    });
    test("#containsSectionsWithoutOverrides returns false when overrides contain\nan override representing the default due date", function() {
      var dueDateList, overridesWithDefaultDueDate;

      overridesWithDefaultDueDate = new AssignmentOverrideCollection(this.overrides.toJSON());
      overridesWithDefaultDueDate.add(AssignmentOverride.defaultDueDate());
      dueDateList = new DueDateList(overridesWithDefaultDueDate, this.sections, this.assignment);
      return strictEqual(dueDateList.containsSectionsWithoutOverrides(), false);
    });
    test("#containsSectionsWithoutOverrides returns false if all sections belong to\nan assignment override", function() {
      this.overrides.add(new AssignmentOverride({
        course_section_id: '3'
      }));
      this.dueDateList = new DueDateList(this.overrides, this.sections, this.assignment);
      return strictEqual(this.dueDateList.containsSectionsWithoutOverrides(), false);
    });
    test("#containsBlankOverrides returns true if at least one override has a\nfalsy due_at", function() {
      return strictEqual(this.dueDateList.containsBlankOverrides(), true);
    });
    test("#containsBlankOverrides returns false if no overrides have a falsy due_at", function() {
      this.overrides.forEach(function(override) {
        return override.set('due_at', Date.now());
      });
      return strictEqual(this.dueDateList.containsBlankOverrides(), false);
    });
    test("#blankOverrides returns blank overrides in the overrides", function() {
      stub(this.overrides, 'blank').returns([1, 2, 3]);
      return deepEqual(this.dueDateList.blankOverrides(), [1, 2, 3]);
    });
    test("updates name to 'everyone' or 'everyone else' when the number of overrides\nchanges", function() {
      var defaultDueDate, defaultSection, override;

      defaultDueDate = AssignmentOverride.defaultDueDate();
      defaultSection = Section.defaultDueDateSection();
      this.overrides = new AssignmentOverrideCollection([defaultDueDate.toJSON()]);
      this.sections = new SectionList([defaultSection]);
      this.dueDateList = new DueDateList(this.overrides, this.sections);
      override = new AssignmentOverride({
        id: '1'
      });
      this.dueDateList.addOverride(override);
      strictEqual(defaultSection.get('name'), 'Everyone Else');
      this.dueDateList.removeOverride(override);
      return strictEqual(defaultSection.get('name'), 'Everyone');
    });
    test("constructor adds an override representing the default due date using the\nassignment's due date, lock_at, and unlock_at, if an assignment is given", function() {
      var override;

      this.dueDateList = new DueDateList(this.overrides, this.sections, this.assignment);
      strictEqual(this.dueDateList.overrides.length, 3);
      override = this.dueDateList.overrides.pop();
      strictEqual(override.get('due_at'), this.date);
      strictEqual(override.get('unlock_at'), this.date);
      return strictEqual(override.get('lock_at'), this.date);
    });
    test("constructor adds a section to the list of sections representing the\nassignment's default due date if an assignment is given", function() {
      this.dueDateList = new DueDateList(this.overrides, this.sections, this.assignment);
      strictEqual(this.dueDateList.sections.length, 4);
      return strictEqual(this.dueDateList.sections.shift().id, Section.defaultDueDateSectionID);
    });
    test("constructor does not add a section if no assignment given", function() {
      return strictEqual(this.dueDateList.sections.length, 3);
    });
    test("constructor does not add an override of no assignment given", function() {
      return strictEqual(this.dueDateList.overrides.length, 2);
    });
    test("#toJSON includes sections", function() {
      return deepEqual(this.dueDateList.toJSON().sections, this.sections.toJSON());
    });
    return test("#toJSON includes overrides", function() {
      return deepEqual(this.dueDateList.toJSON().overrides, this.overrides.toJSON());
    });
  });

}).call(this);

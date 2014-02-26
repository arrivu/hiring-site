(function() {
  define(['compiled/views/assignments/SectionDropdownView', 'compiled/models/AssignmentOverride', 'compiled/models/Section'], function(SectionDropdownView, AssignmentOverride, Section) {
    module("SectionDropdownView", {
      setup: function() {
        this.override = new AssignmentOverride({
          course_section_id: '1'
        });
        this.sections = [
          new Section({
            id: 1,
            name: 'foo'
          }), new Section({
            id: 2,
            name: 'bar'
          })
        ];
        this.view = new SectionDropdownView({
          sections: this.sections,
          override: this.override
        });
        return this.view.render();
      }
    });
    test("updates the course_section_id when the form element changes", function() {
      this.view.$el.val('2').trigger('change');
      return strictEqual(this.override.get('course_section_id'), 2);
    });
    return test("renders all of the sections", function() {
      var viewHTML;

      viewHTML = this.view.$el.html();
      return this.sections.forEach(function(section) {
        return ok(viewHTML.match(section.get('name')));
      });
    });
  });

}).call(this);

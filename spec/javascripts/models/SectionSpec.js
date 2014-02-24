(function() {
  define(['compiled/models/Section', 'i18n!overrides'], function(Section, I18n) {
    module("Section");
    test("#initialize doesn't assign value for id if not given", function() {
      var section;

      section = new Section;
      return strictEqual(section.id, void 0);
    });
    test("#Section.defaultDueDateSectionID is 0", function() {
      return strictEqual(Section.defaultDueDateSectionID, 0);
    });
    test("Section.defaultDueDateSection returns a section with id of 0", function() {
      var section;

      section = Section.defaultDueDateSection();
      strictEqual(section.id, 0);
      return strictEqual(section.get('name'), I18n.t('overrides.everyone', 'Everyone'));
    });
    test("#isDefaultDueDateSection returns true if id is 0", function() {
      return strictEqual(Section.defaultDueDateSection().isDefaultDueDateSection(), true);
    });
    return test("#isDefaultDueDateSection returns false if id is not 0", function() {
      return strictEqual((new Section).isDefaultDueDateSection(), false);
    });
  });

}).call(this);

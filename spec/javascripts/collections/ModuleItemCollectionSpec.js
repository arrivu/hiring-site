(function() {
  define(['compiled/collections/ModuleItemCollection'], function(ModuleItemCollection) {
    return module('ModuleItemCollection', test("generates the correct fetch url", function() {
      var collection, course_id, module_id;

      course_id = 5;
      module_id = 10;
      collection = new ModuleItemCollection([], {
        course_id: course_id,
        module_id: module_id
      });
      return equal(collection.url(), "/api/v1/courses/" + course_id + "/modules/" + module_id + "/items");
    }));
  });

}).call(this);

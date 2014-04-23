(function() {
  define(['compiled/collections/ModuleCollection'], function(ModuleCollection) {
    return module('ModuleCollection', test("generates the correct fetch url", function() {
      var collection, course_id;

      course_id = 5;
      collection = new ModuleCollection([], {
        course_id: course_id
      });
      return equal(collection.url(), "/api/v1/courses/" + course_id + "/modules");
    }));
  });

}).call(this);

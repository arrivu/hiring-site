(function() {
  define(['compiled/collections/ContentMigrationIssueCollection'], function(ContentMigrationIssueCollection) {
    return module('ContentMigrationIssueCollection', test("generates the correct fetch url", function() {
      var cmiCollection, content_migration_id, course_id;

      course_id = 5;
      content_migration_id = 10;
      cmiCollection = new ContentMigrationIssueCollection([], {
        course_id: course_id,
        content_migration_id: content_migration_id
      });
      return equal(cmiCollection.url(), "/api/v1/courses/" + course_id + "/content_migrations/" + content_migration_id + "/migration_issues");
    }));
  });

}).call(this);

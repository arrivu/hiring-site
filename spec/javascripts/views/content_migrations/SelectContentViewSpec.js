(function() {
  define(['Backbone', 'compiled/views/content_migrations/SelectContentView', 'compiled/models/ProgressingContentMigration'], function(Backbone, SelectContentView, ProgressingMigration) {
    module('SelectContentView: Main Behaviors', {
      setup: function() {
        this.$fixtures = $('#fixtures');
        this.model = new ProgressingMigration({
          id: 5,
          course_id: 42
        });
        this.selectContentView = new SelectContentView({
          model: this.model,
          title: 'Select Content',
          width: 600,
          height: 400,
          fixDialogButtons: false
        });
        this.server = sinon.fakeServer.create();
        return this.$fixtures.append(this.selectContentView.$el);
      },
      teardown: function() {
        this.server.restore();
        return this.selectContentView.remove();
      }
    });
    return test('render top level checkboxes when opened', function() {
      var $checkboxes;

      this.server.respondWith('GET', '/api/v1/courses/42/content_migrations/5/selective_data', [
        200, {
          "Content-Type": "application/json"
        }, JSON.stringify([
          {
            "type": "course_settings",
            "property": "copy[all_course_settings]",
            "title": "Course Settings"
          }, {
            "type": "syllabus_body",
            "property": "copy[all_syllabus_body]",
            "title": "Syllabus Body"
          }
        ])
      ]);
      this.selectContentView.open();
      this.server.respond();
      $checkboxes = this.selectContentView.$el.find('[type=checkbox]');
      return equal($checkboxes.length, 2, "Renders all checkboxes");
    });
  });

}).call(this);

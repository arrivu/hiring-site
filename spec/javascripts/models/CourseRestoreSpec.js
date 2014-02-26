(function() {
  define(['Backbone', 'compiled/models/CourseRestore', 'jquery'], function(Backbone, CourseRestoreModel, $) {
    var courseJSON, progressCompletedJSON, progressQueuedJSON;

    progressCompletedJSON = {
      completion: 0,
      context_id: 4,
      context_type: "Account",
      created_at: "2013-03-08T16:37:46-07:00",
      id: 28,
      message: null,
      tag: "course_batch_update",
      updated_at: "2013-03-08T16:37:46-07:00",
      url: "http://localhost:3000/api/v1/progress/28",
      user_id: 51,
      workflow_state: "completed"
    };
    progressQueuedJSON = {
      completion: 0,
      context_id: 4,
      context_type: "Account",
      created_at: "2013-03-08T16:37:46-07:00",
      id: 28,
      message: null,
      tag: "course_batch_update",
      updated_at: "2013-03-08T16:37:46-07:00",
      url: "http://localhost:3000/api/v1/progress/28",
      user_id: 51,
      workflow_state: "queued"
    };
    courseJSON = {
      account_id: 6,
      course_code: "Super",
      default_view: "feed",
      end_at: null,
      enrollments: [],
      hide_final_grades: false,
      id: 58,
      name: "Super Fun Deleted Course",
      sis_course_id: null,
      start_at: null,
      workflow_state: "deleted"
    };
    module('CourseRestore', {
      setup: function() {
        this.account_id = 4;
        this.course_id = 42;
        this.courseRestore = new CourseRestoreModel({
          account_id: this.account_id
        });
        this.server = sinon.fakeServer.create();
        return this.clock = sinon.useFakeTimers();
      },
      teardown: function() {
        this.server.restore();
        this.clock.restore();
        return this.acocunt_id = null;
      }
    });
    test("triggers 'searching' when search is called", function() {
      var callback;

      callback = sinon.spy();
      this.courseRestore.on('searching', callback);
      this.courseRestore.search(this.account_id);
      return ok(callback.called, "Searching event is called when searching");
    });
    test("populates CourseRestore model with response, keeping its original account_id", function() {
      this.courseRestore.search(this.course_id);
      this.server.respond('GET', this.courseRestore.searchUrl(), [
        200, {
          'Content-Type': 'application/json'
        }, JSON.stringify(courseJSON)
      ]);
      equal(this.courseRestore.get('account_id'), this.account_id, "account id stayed the same");
      return equal(this.courseRestore.get('id'), courseJSON.id, "course id was updated");
    });
    test("responds with a deffered object", function() {
      var dfd;

      dfd = this.courseRestore.restore();
      return ok($.isFunction(dfd.done, "This is a deffered object"));
    });
    return test("restores a course after search finds a deleted course", 2, function() {
      var dfd;

      this.courseRestore.search(this.course_id);
      this.server.respond('GET', this.courseRestore.searchUrl(), [
        200, {
          'Content-Type': 'application/json'
        }, JSON.stringify(courseJSON)
      ]);
      dfd = this.courseRestore.restore();
      this.server.respond('PUT', "" + (this.courseRestore.baseUrl()) + "/?course_ids[]=" + (this.courseRestore.get('id')) + "&event=undelete", [
        200, {
          'Content-Type': 'application/json'
        }, JSON.stringify(progressQueuedJSON)
      ]);
      this.clock.tick(1000);
      this.server.respond('GET', progressQueuedJSON.url, [
        200, {
          'Content-Type': 'application/json'
        }, JSON.stringify(progressCompletedJSON)
      ]);
      ok(dfd.isResolved(), "All ajax request in this deferred object should be resolved");
      return equal(this.courseRestore.get('workflow_state'), 'unpublished');
    });
  });

}).call(this);

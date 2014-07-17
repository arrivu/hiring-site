(function() {
  define(['compiled/models/Assignment', 'compiled/models/DateGroup'], function(Assignment, DateGroup) {
    var _this = this;

    module("Assignment");
    module("Assignment#isQuiz");
    test("returns true if record is a quiz", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['online_quiz']);
      return deepEqual(assignment.isQuiz(), true);
    });
    test("returns false if record is not a quiz", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['on_paper']);
      return deepEqual(assignment.isQuiz(), false);
    });
    module("Assignment#isDiscussionTopic");
    test("returns true if record is discussion topic", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.submissionTypes(['discussion_topic']);
      return deepEqual(assignment.isDiscussionTopic(), true);
    });
    test("returns false if record is discussion topic", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.submissionTypes(['on_paper']);
      return deepEqual(assignment.isDiscussionTopic(), false);
    });
    module("Assignment#isExternalTool");
    test("returns true if record is external tool", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.submissionTypes(['external_tool']);
      return deepEqual(assignment.isExternalTool(), true);
    });
    test("returns false if record is not external tool", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.submissionTypes(['on_paper']);
      return deepEqual(assignment.isExternalTool(), false);
    });
    module("Assignment#isNotGraded");
    test("returns true if record is not graded", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.submissionTypes(['not_graded']);
      return deepEqual(assignment.isNotGraded(), true);
    });
    test("returns false if record is graded", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.gradingType('percent');
      assignment.submissionTypes(['online_url']);
      return deepEqual(assignment.isNotGraded(), false);
    });
    module("Assignment#isAssignment");
    test("returns true if record is not quiz,ungraded,external tool, or discussion", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['online_url']);
      return deepEqual(assignment.isAssignment(), true);
    });
    test("returns true if record has no submission types", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      return deepEqual(assignment.isAssignment(), true);
    });
    test("returns false if record is quiz,ungraded, external tool, or discussion", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['online_quiz']);
      return deepEqual(assignment.isAssignment(), false);
    });
    module("Assignment#asignmentType as a setter");
    test("sets the record's submission_types to the value", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', 'online_quiz');
      assignment.assignmentType('discussion_topic');
      deepEqual(assignment.assignmentType(), 'discussion_topic');
      return deepEqual(assignment.get('submission_types'), ['discussion_topic']);
    });
    test("when value 'assignment', sets record value to 'none'", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', 'online_quiz');
      assignment.assignmentType('assignment');
      deepEqual(assignment.assignmentType(), 'assignment');
      return deepEqual(assignment.get('submission_types'), ['none']);
    });
    module("Assignment#assignmentType as a getter");
    test("returns 'assignment' if not quiz, discussion topic, external tool, or\nungraded", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['on_paper']);
      return deepEqual(assignment.assignmentType(), 'assignment');
    });
    test("returns correct assignment type if not 'assignment'", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['online_quiz']);
      return deepEqual(assignment.assignmentType(), 'online_quiz');
    });
    module("Assignment#dueAt as a getter");
    test("returns record's due_at", function() {
      var assignment, date;

      date = Date.now();
      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('due_at', date);
      return deepEqual(assignment.dueAt(), date);
    });
    module("Assignment#dueAt as a setter");
    test("sets the record's due_at", function() {
      var assignment, date;

      date = Date.now();
      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('due_at', null);
      assignment.dueAt(date);
      return deepEqual(assignment.dueAt(), date);
    });
    module("Assignment#unlockAt as a getter");
    test("gets the records unlock_at", function() {
      var assignment, date;

      date = Date.now();
      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('unlock_at', date);
      return deepEqual(assignment.unlockAt(), date);
    });
    module("Assignment#unlockAt as a setter");
    test("sets the record's unlock_at", function() {
      var assignment, date;

      date = Date.now();
      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('unlock_at', null);
      assignment.unlockAt(date);
      return deepEqual(assignment.unlockAt(), date);
    });
    module("Assignment#lockAt as a getter");
    test("gets the records lock_at", function() {
      var assignment, date;

      date = Date.now();
      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('lock_at', date);
      return deepEqual(assignment.lockAt(), date);
    });
    module("Assignment#lockAt as a setter");
    test("sets the record's lock_at", function() {
      var assignment, date;

      date = Date.now();
      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('unlock_at', null);
      assignment.lockAt(date);
      return deepEqual(assignment.lockAt(), date);
    });
    module("Assignment#description as a getter");
    test("returns the record's description", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('description', 'desc');
      return deepEqual(assignment.description(), 'desc');
    });
    module("Assignment#description as a setter");
    test("sets the record's desciption", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('description', null);
      assignment.description('desc');
      deepEqual(assignment.description(), 'desc');
      return deepEqual(assignment.get('description'), 'desc');
    });
    module("Assignment#name as a getter");
    test("returns the record's name", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('name', 'Todd');
      return deepEqual(assignment.name(), 'Todd');
    });
    module("Assignment#name as a setter");
    test("sets the record's name", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('name', 'NotTodd');
      assignment.name('Todd');
      return deepEqual(assignment.get('name'), 'Todd');
    });
    module("Assignment#pointsPossible as a setter");
    test("sets the record's points_possible", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('points_possible', 0);
      assignment.pointsPossible(12);
      deepEqual(assignment.pointsPossible(), 12);
      return deepEqual(assignment.get('points_possible'), 12);
    });
    module("Assignment#assignmentGroupId as a setter");
    test("sets the record's assignment group id", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('assignment_group_id', 0);
      assignment.assignmentGroupId(12);
      deepEqual(assignment.assignmentGroupId(), 12);
      return deepEqual(assignment.get('assignment_group_id'), 12);
    });
    module("Assignment#gradingType as a setter");
    test("sets the record's grading type", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('grading_type', 'points');
      assignment.gradingType('percent');
      deepEqual(assignment.gradingType(), 'percent');
      return deepEqual(assignment.get('grading_type'), 'percent');
    });
    module("Assignment#submissionType");
    test("returns 'none' if record's submission_types is ['none']", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['none']);
      return deepEqual(assignment.submissionType(), 'none');
    });
    test("returns 'on_paper' if record's submission_types includes on_paper", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['on_paper']);
      return deepEqual(assignment.submissionType(), 'on_paper');
    });
    test("returns online submission otherwise", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['online_upload']);
      return deepEqual(assignment.submissionType(), 'online');
    });
    module("Assignment#acceptsOnlineUpload");
    test("returns true if record submission types includes online_upload", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['online_upload']);
      return deepEqual(assignment.acceptsOnlineUpload(), true);
    });
    test("returns false if submission types doesn't include online_upload", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', []);
      return deepEqual(assignment.acceptsOnlineUpload(), false);
    });
    module("Assignment#acceptsOnlineURL");
    test("returns true if assignment allows online url", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['online_url']);
      return deepEqual(assignment.acceptsOnlineURL(), true);
    });
    test("returns false if submission types doesn't include online_url", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', []);
      return deepEqual(assignment.acceptsOnlineURL(), false);
    });
    module("Assignment#acceptsMediaRecording");
    test("returns true if submission types includes media recordings", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['media_recording']);
      return deepEqual(assignment.acceptsMediaRecording(), true);
    });
    module("Assignment#acceptsOnlineTextEntries");
    test("returns true if submission types includes online text entry", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['online_text_entry']);
      return deepEqual(assignment.acceptsOnlineTextEntries(), true);
    });
    module("Assignment#peerReviews");
    test("returns the peer_reviews on the record if no args passed", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('peer_reviews', false);
      return deepEqual(assignment.peerReviews(), false);
    });
    test("sets the record's peer_reviews if args passed", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('peer_reviews', false);
      assignment.peerReviews(true);
      return deepEqual(assignment.peerReviews(), true);
    });
    module("Assignment#automaticPeerReviews");
    test("returns the automatic_peer_reviews on the model if no args passed", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('automatic_peer_reviews', false);
      return deepEqual(assignment.automaticPeerReviews(), false);
    });
    test("sets the automatic_peer_reviews on the record if args passed", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('automatic_peer_reviews', false);
      assignment.automaticPeerReviews(true);
      return deepEqual(assignment.automaticPeerReviews(), true);
    });
    module("Assignment#notifyOfUpdate");
    test("returns record's notifyOfUpdate if no args passed", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('notify_of_update', false);
      return deepEqual(assignment.notifyOfUpdate(), false);
    });
    test("sets record's notifyOfUpdate if args passed", function() {
      var assignment;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.notifyOfUpdate(false);
      return deepEqual(assignment.notifyOfUpdate(), false);
    });
    module("Assignment#multipleDueDates");
    test("checks for multiple due dates from assignment overrides", function() {
      var assignment;

      assignment = new Assignment({
        all_dates: [
          {
            title: "Winter"
          }, {
            title: "Summer"
          }
        ]
      });
      return ok(assignment.multipleDueDates());
    });
    test("checks for no multiple due dates from assignment overrides", function() {
      var assignment;

      assignment = new Assignment;
      return ok(!assignment.multipleDueDates());
    });
    module("Assignment#allDates");
    test("gets the due dates from the assignment overrides", function() {
      var allDates, assignment, dates, dueAt, first;

      dueAt = new Date("2013-08-20 11:13:00");
      dates = [
        new DateGroup({
          due_at: dueAt,
          title: "Everyone"
        })
      ];
      assignment = new Assignment({
        all_dates: dates
      });
      allDates = assignment.allDates();
      first = allDates[0];
      equal(first.dueAt + "", dueAt + "");
      return equal(first.dueFor, "Everyone");
    });
    test("gets empty due dates when there are no dates", function() {
      var assignment;

      assignment = new Assignment;
      return deepEqual(assignment.allDates(), []);
    });
    module("Assignment#toView");
    test("returns the assignment's name", function() {
      var assignment, json;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.name('Todd');
      json = assignment.toView();
      return deepEqual(json.name, 'Todd');
    });
    test("returns the assignment's dueAt", function() {
      var assignment, date, json;

      date = Date.now();
      assignment = new Assignment({
        name: 'foo'
      });
      assignment.dueAt(date);
      json = assignment.toView();
      return deepEqual(json.dueAt, date);
    });
    test("includes the assignment's description", function() {
      var assignment, description, json;

      description = "Yo yo fasho";
      assignment = new Assignment({
        name: 'foo'
      });
      assignment.description(description);
      json = assignment.toView();
      return deepEqual(json.description, description);
    });
    test("returns assignment's points possible", function() {
      var assignment, json, pointsPossible;

      pointsPossible = 12;
      assignment = new Assignment({
        name: 'foo'
      });
      assignment.pointsPossible(pointsPossible);
      json = assignment.toView();
      return deepEqual(json.pointsPossible, pointsPossible);
    });
    test("returns assignment's lockAt", function() {
      var assignment, json, lockAt;

      lockAt = Date.now();
      assignment = new Assignment({
        name: 'foo'
      });
      assignment.lockAt(lockAt);
      json = assignment.toView();
      return deepEqual(json.lockAt, lockAt);
    });
    test("includes assignment's unlockAt", function() {
      var assignment, json, unlockAt;

      unlockAt = Date.now();
      assignment = new Assignment({
        name: 'foo'
      });
      assignment.unlockAt(unlockAt);
      json = assignment.toView();
      return deepEqual(json.unlockAt, unlockAt);
    });
    test("includes assignment's gradingType", function() {
      var assignment, gradingType, json;

      gradingType = 'percent';
      assignment = new Assignment({
        name: 'foo'
      });
      assignment.gradingType(gradingType);
      json = assignment.toView();
      return deepEqual(json.gradingType, gradingType);
    });
    test("includes assignment's notifyOfUpdate", function() {
      var assignment, json, notifyOfUpdate;

      notifyOfUpdate = false;
      assignment = new Assignment({
        name: 'foo'
      });
      assignment.notifyOfUpdate(notifyOfUpdate);
      json = assignment.toView();
      return deepEqual(json.notifyOfUpdate, notifyOfUpdate);
    });
    test("includes assignment's peerReviews", function() {
      var assignment, json, peerReviews;

      peerReviews = false;
      assignment = new Assignment({
        name: 'foo'
      });
      assignment.peerReviews(peerReviews);
      json = assignment.toView();
      return deepEqual(json.peerReviews, peerReviews);
    });
    test("includes assignment's automaticPeerReviews value", function() {
      var assignment, autoPeerReviews, json;

      autoPeerReviews = false;
      assignment = new Assignment({
        name: 'foo'
      });
      assignment.automaticPeerReviews(autoPeerReviews);
      json = assignment.toView();
      return deepEqual(json.automaticPeerReviews, autoPeerReviews);
    });
    test("includes boolean indicating whether or not assignment accepts uploads", function() {
      var assignment, json;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['online_upload']);
      json = assignment.toView();
      return deepEqual(json.acceptsOnlineUpload, true);
    });
    test("includes whether or not assignment accepts media recordings", function() {
      var assignment, json;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['media_recording']);
      json = assignment.toView();
      return deepEqual(json.acceptsMediaRecording, true);
    });
    test("includes submissionType", function() {
      var assignment, json;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['on_paper']);
      json = assignment.toView();
      return deepEqual(json.submissionType, 'on_paper');
    });
    test("includes acceptsOnlineTextEntries", function() {
      var assignment, json;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['online_text_entry']);
      json = assignment.toView();
      return deepEqual(json.acceptsOnlineTextEntries, true);
    });
    test("includes acceptsOnlineURL", function() {
      var assignment, json;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.set('submission_types', ['online_url']);
      json = assignment.toView();
      return deepEqual(json.acceptsOnlineURL, true);
    });
    test("includes allowedExtensions", function() {
      var assignment, json;

      assignment = new Assignment({
        name: 'foo'
      });
      assignment.allowedExtensions([]);
      json = assignment.toView();
      return deepEqual(json.allowedExtensions, []);
    });
    test("includes htmlUrl", function() {
      var assignment, json;

      assignment = new Assignment({
        html_url: 'http://example.com/assignments/1'
      });
      json = assignment.toView();
      return deepEqual(json.htmlUrl, 'http://example.com/assignments/1');
    });
    test("includes htmlEditUrl", function() {
      var assignment, json;

      assignment = new Assignment({
        html_url: 'http://example.com/assignments/1'
      });
      json = assignment.toView();
      return deepEqual(json.htmlEditUrl, 'http://example.com/assignments/1/edit');
    });
    test("includes multipleDueDates", function() {
      var assignment, json;

      assignment = new Assignment({
        all_dates: [
          {
            title: "Summer"
          }, {
            title: "Winter"
          }
        ]
      });
      json = assignment.toView();
      return deepEqual(json.multipleDueDates, true);
    });
    test("includes allDates", function() {
      var assignment, json;

      assignment = new Assignment({
        all_dates: [
          {
            title: "Summer"
          }, {
            title: "Winter"
          }
        ]
      });
      json = assignment.toView();
      return equal(json.allDates.length, 2);
    });
    return test("includes isQuiz", function() {
      var assignment, json;

      assignment = new Assignment({
        "submission_types": ["online_quiz"]
      });
      json = assignment.toView();
      return ok(json.isQuiz);
    });
  });

}).call(this);

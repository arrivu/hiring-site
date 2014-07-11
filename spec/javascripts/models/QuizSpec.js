(function() {
  define(['jquery', 'compiled/models/Quiz', 'compiled/models/Assignment', 'compiled/collections/AssignmentOverrideCollection', 'jquery.ajaxJSON'], function($, Quiz, Assignment, AssignmentOverrideCollection) {
    module('Quiz', {
      setup: function() {
        this.quiz = new Quiz({
          id: 1,
          html_url: 'http://localhost:3000/courses/1/quizzes/24'
        });
        return this.ajaxStub = sinon.stub($, 'ajaxJSON');
      },
      teardown: function() {
        return $.ajaxJSON.restore();
      }
    });
    test('#initialize ignores assignment if not given', function() {
      return ok(!this.quiz.get('assignment'));
    });
    test('#initialize sets assignment', function() {
      var assign;

      assign = {
        id: 1,
        title: 'Foo Bar'
      };
      this.quiz = new Quiz({
        assignment: assign
      });
      return equal(this.quiz.get('assignment').constructor, Assignment);
    });
    test('#initialize ignores assignment_overrides if not given', function() {
      return ok(!this.quiz.get('assignment_overrides'));
    });
    test('#initialize assigns assignment_override collection', function() {
      this.quiz = new Quiz({
        assignment_overrides: []
      });
      return equal(this.quiz.get('assignment_overrides').constructor, AssignmentOverrideCollection);
    });
    test('#initialize should set url from html url', function() {
      return equal(this.quiz.get('url'), 'http://localhost:3000/courses/1/quizzes/1');
    });
    test('#initialize should set edit_url from html url', function() {
      return equal(this.quiz.get('edit_url'), 'http://localhost:3000/courses/1/quizzes/1/edit');
    });
    test('#initialize should set publish_url from html url', function() {
      return equal(this.quiz.get('publish_url'), 'http://localhost:3000/courses/1/quizzes/publish');
    });
    test('#initialize should set unpublish_url from html url', function() {
      return equal(this.quiz.get('unpublish_url'), 'http://localhost:3000/courses/1/quizzes/unpublish');
    });
    test('#initialize should set title_label from title', function() {
      this.quiz = new Quiz({
        title: 'My Quiz!',
        readable_type: 'Quiz'
      });
      return equal(this.quiz.get('title_label'), 'My Quiz!');
    });
    test('#initialize should set title_label from readable_type', function() {
      this.quiz = new Quiz({
        readable_type: 'Quiz'
      });
      return equal(this.quiz.get('title_label'), 'Quiz');
    });
    test('#initialize defaults publishable to true', function() {
      return ok(this.quiz.get('publishable'));
    });
    test('#initialize sets publishable to false', function() {
      this.quiz = new Quiz({
        publishable: false
      });
      return ok(!this.quiz.get('publishable'));
    });
    test('#initialize sets publishable from can_unpublish and published', function() {
      this.quiz = new Quiz({
        can_unpublish: false,
        published: true
      });
      return ok(!this.quiz.get('publishable'));
    });
    test("#initialize sets question count", function() {
      this.quiz = new Quiz({
        question_count: 1,
        published: true
      });
      equal(this.quiz.get('question_count_label'), "1 Question");
      this.quiz = new Quiz({
        question_count: 2,
        published: true
      });
      return equal(this.quiz.get('question_count_label'), "2 Questions");
    });
    test("#initialize sets possible points count with no points", function() {
      this.quiz = new Quiz();
      return equal(this.quiz.get('possible_points_label'), '');
    });
    test("#initialize sets possible points count with 0 points", function() {
      this.quiz = new Quiz({
        points_possible: 0
      });
      return equal(this.quiz.get('possible_points_label'), '0 pts');
    });
    test("#initialize sets possible points count with 1 points", function() {
      this.quiz = new Quiz({
        points_possible: 1
      });
      return equal(this.quiz.get('possible_points_label'), "1 pt");
    });
    test("#initialize sets possible points count with 2 points", function() {
      this.quiz = new Quiz({
        points_possible: 2
      });
      return equal(this.quiz.get('possible_points_label'), "2 pts");
    });
    test('#publish saves to the server', function() {
      this.quiz.publish();
      return ok(this.ajaxStub.called);
    });
    test('#publish sets published attribute to true', function() {
      this.quiz.publish();
      return ok(this.quiz.get('published'));
    });
    test('#unpublish saves to the server', function() {
      this.quiz.unpublish();
      return ok(this.ajaxStub.called);
    });
    return test('#unpublish sets published attribute to false', function() {
      this.quiz.unpublish();
      return ok(!this.quiz.get('published'));
    });
  });

}).call(this);

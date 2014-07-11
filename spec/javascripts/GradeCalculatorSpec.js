(function() {
  var __slice = [].slice;

  define(['compiled/grade_calculator', 'underscore'], function(GradeCalculator, _) {
    var assertDropped, assertGrade;

    assertGrade = function(result, currentOrFinal, score, possible) {
      equal(result[currentOrFinal].score, score);
      return equal(result[currentOrFinal].possible, possible);
    };
    assertDropped = function() {
      var grades, submissions;

      submissions = arguments[0], grades = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return _(grades).each(function(_arg) {
        var possible, score, submission;

        score = _arg[0], possible = _arg[1];
        submission = _(submissions).find(function(s) {
          return s.score === score && s.possible === possible;
        });
        return equal(submission.drop, true);
      });
    };
    module("GradeCalculator", {
      setup: function() {
        this.group = {
          id: 1
        };
        return this.setup_grades(this.group, [[100, 100], [42, 91], [14, 55], [3, 38], [null, 1000]]);
      },
      setup_grades: function(group, grades) {
        var assignments, submissions,
          _this = this;

        this.assignment_id || (this.assignment_id = 0);
        assignments = grades.map(function(_arg, i) {
          var assignment, possible, z;

          z = _arg[0], possible = _arg[1];
          return assignment = {
            points_possible: possible,
            id: _this.assignment_id + i
          };
        });
        this.submissions || (this.submissions = []);
        submissions = grades.map(function(_arg, i) {
          var score, submission, z;

          score = _arg[0], z = _arg[1];
          return submission = {
            assignment_id: _this.assignment_id + i,
            score: score
          };
        });
        this.assignment_id += grades.length;
        this.submissions = this.submissions.concat(submissions);
        return group.assignments = assignments;
      }
    });
    test("without submissions or assignments", function() {
      var group, result;

      group = {
        id: 1,
        rules: {},
        assignments: []
      };
      result = GradeCalculator.calculate([], [group]);
      assertGrade(result, 'current', 0, 0);
      return assertGrade(result, 'final', 0, 0);
    });
    test("without submissions", function() {
      var result;

      this.group.rules = {};
      result = GradeCalculator.calculate([], [this.group]);
      assertGrade(result, 'current', 0, 0);
      return assertGrade(result, 'final', 0, 1284);
    });
    test("should work with submissions that have 0 points possible", function() {
      var result;

      this.submissions = [];
      this.group.rules = {};
      this.setup_grades(this.group, [[10, 0], [10, 10], [10, 10], [null, 10]]);
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 30, 20);
      assertGrade(result, 'final', 30, 30);
      this.group.rules = {
        drop_lowest: 1
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 20, 10);
      return assertGrade(result, 'final', 30, 20);
    });
    test("no submissions have points possible", function() {
      var result;

      this.submissions = [];
      this.setup_grades(this.group, [[10, 0], [5, 0], [20, 0], [0, 0]]);
      this.group.rules = {
        drop_lowest: 1
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 35, 0);
      assertDropped(result.group_sums[0]['current'].submissions, [0, 0]);
      this.group.rules = {
        drop_lowest: 2,
        drop_highest: 1
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 10, 0);
      return assertDropped(result.group_sums[0]['current'].submissions, [0, 0], [5, 0], [20, 0]);
    });
    test("no drop rules", function() {
      var result;

      this.group.rules = {};
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 159, 284);
      return assertGrade(result, 'final', 159, 1284);
    });
    test("drop lowest", function() {
      var result;

      this.group.rules = {
        drop_lowest: 1
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 156, 246);
      assertDropped(result.group_sums[0].current.submissions, [3, 38]);
      assertGrade(result, 'final', 159, 284);
      assertDropped(result.group_sums[0]['final'].submissions, [0, 1000]);
      this.group.rules = {
        drop_lowest: 2
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 103, 138);
      assertDropped(result.group_sums[0].current.submissions, [42, 91], [14, 55]);
      assertGrade(result, 'final', 156, 246);
      return assertDropped(result.group_sums[0]['final'].submissions, [0, 1000], [3, 38]);
    });
    test("drop lowest (again)", function() {
      var result;

      this.submissions = [];
      this.setup_grades(this.group, [[30, null], [30, null], [30, null], [31, 31], [21, 21], [30, 30], [30, 30], [30, 30], [30, 30], [30, 30], [30, 30], [30, 30], [30, 30], [30, 30], [30, 30], [29.3, 30], [30, 30], [30, 30], [30, 30], [12, 0], [30, null]]);
      this.group.rules = {
        drop_lowest: 2
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'final', 543, 411);
      return assertDropped(result.group_sums[0]['final'].submissions, [31, 31], [29.3, 30]);
    });
    test("drop highest", function() {
      var result;

      this.group.rules = {
        drop_highest: 1
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 59, 184);
      assertDropped(result.group_sums[0].current.submissions, [100, 100]);
      assertGrade(result, 'final', 59, 1184);
      assertDropped(result.group_sums[0]['final'].submissions, [100, 100]);
      this.group.rules = {
        drop_highest: 2
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 17, 93);
      assertDropped(result.group_sums[0].current.submissions, [100, 100], [42, 91]);
      assertGrade(result, 'final', 17, 1093);
      assertDropped(result.group_sums[0]['final'].submissions, [100, 100], [42, 91]);
      this.group.rules = {
        drop_highest: 3
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 3, 38);
      assertDropped(result.group_sums[0].current.submissions, [100, 100], [42, 91], [14, 55]);
      assertGrade(result, 'final', 3, 1038);
      return assertDropped(result.group_sums[0]['final'].submissions, [100, 100], [42, 91], [14, 55]);
    });
    test("drop highest (again)", function() {
      var result;

      this.submissions = [];
      this.setup_grades(this.group, [[0, 10], [10, 20], [28, 50], [91, 100]]);
      this.group.rules = {
        drop_highest: 1
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 38, 80);
      assertDropped(result.group_sums[0].current.submissions, [91, 100]);
      this.group.rules = {
        drop_highest: 2
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 10, 30);
      assertDropped(result.group_sums[0].current.submissions, [28, 50], [91, 100]);
      this.group.rules = {
        drop_highest: 3
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 0, 10);
      return assertDropped(result.group_sums[0].current.submissions, [10, 20], [28, 50], [91, 100]);
    });
    test("unreasonable drop rules", function() {
      var result;

      this.submissions = [];
      this.setup_grades(this.group, [[10, 10], [9, 10], [8, 10]]);
      this.group.rules = {
        drop_lowest: 1000,
        drop_highest: 1000
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 10, 10);
      return assertDropped(result.group_sums[0].current.submissions, [9, 10], [8, 10]);
    });
    test("never drop", function() {
      var result;

      this.group.rules = {
        drop_lowest: 1,
        never_drop: [3]
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 145, 229);
      assertDropped(result.group_sums[0].current.submissions, [14, 55]);
      assertGrade(result, 'final', 159, 284);
      assertDropped(result.group_sums[0]['final'].submissions, [0, 1000]);
      this.assignment_id = 0;
      this.submissions = [];
      this.setup_grades(this.group, [[10, 20], [5, 10], [20, 40], [0, 100]]);
      this.group.rules = {
        drop_lowest: 1,
        never_drop: [3]
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 30, 160);
      assertDropped(result.group_sums[0].current.submissions, [5, 10]);
      this.assignment_id = 0;
      this.submissions = [];
      this.setup_grades(this.group, [[10, 20], [5, 10], [20, 40], [100, 100]]);
      this.group.rules = {
        drop_lowest: 1,
        never_drop: [3]
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 115, 130);
      assertDropped(result.group_sums[0].current.submissions, [20, 40]);
      this.assignment_id = 0;
      this.submissions = [];
      this.setup_grades(this.group, [[101.9, 100], [105.65, 100], [103.8, 100], [0, 0]]);
      this.group.rules = {
        drop_lowest: 1,
        never_drop: [2]
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 209.45, 200);
      return assertDropped(result.group_sums[0].current.submissions, [101.9, 100]);
    });
    test("grade dropping in ridiculous circumstances", function() {
      var result;

      this.setup_grades(this.group, [[null, 20], [3, 10], [null, 10], [null, 100000000000000007629769841091887003294964970946560], [null, null]]);
      this.group.rules = {
        drop_lowest: 2
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      assertGrade(result, 'current', 3, 10);
      return assertGrade(result, 'final', 3, 20);
    });
    test("assignment groups with 0 points possible", function() {
      var groups, result;

      this.submissions = [];
      this.group1 = this.group;
      this.group1.group_weight = 50;
      this.group2 = {
        id: 2,
        group_weight: 25
      };
      this.group3 = {
        id: 3,
        group_weight: 25
      };
      this.group4 = {
        id: 4,
        group_weight: 10
      };
      groups = [this.group1, this.group2, this.group3, this.group4];
      this.setup_grades(this.group1, [[9, 10]]);
      this.setup_grades(this.group2, [[5, 10]]);
      this.setup_grades(this.group4, [[10, 0], [5, 0]]);
      result = GradeCalculator.calculate(this.submissions, groups, 'percent');
      assertGrade(result, 'current', 76.7, 100);
      assertGrade(result, 'final', 76.7, 100);
      result = GradeCalculator.calculate(this.submissions, groups, 'equal');
      assertGrade(result, 'current', 29, 20);
      return assertGrade(result, 'final', 29, 20);
    });
    return test("grade should always drop assignments consistently", function() {
      var dropped, dropped2, firstDroppedAssignment, result;

      this.submissions = [];
      this.setup_grades(this.group, [[9, 10], [9, 10], [9, 10], [9, 10]]);
      this.group.rules = {
        drop_lowest: 1
      };
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      dropped = _(result.group_sums[0].current.submissions).find(function(s) {
        return s.drop;
      });
      firstDroppedAssignment = dropped.submission.assignment_id;
      this.submissions.reverse();
      result = GradeCalculator.calculate(this.submissions, [this.group]);
      dropped2 = _(result.group_sums[0].current.submissions).find(function(s) {
        return s.drop;
      });
      return equal(firstDroppedAssignment, dropped2.submission.assignment_id);
    });
  });

}).call(this);

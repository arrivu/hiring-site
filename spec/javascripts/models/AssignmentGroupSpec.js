(function() {
  define(['compiled/models/Assignment', 'compiled/models/AssignmentGroup'], function(Assignment, AssignmentGroup) {
    module("AssignmentGroup");
    test("#hasRules returns true if group has regular rules", function() {
      var ag;

      ag = new AssignmentGroup({
        rules: {
          drop_lowest: 1
        }
      });
      return strictEqual(ag.hasRules(), true);
    });
    test("#hasRules returns true if group has never drop rules", function() {
      var ag;

      ag = new AssignmentGroup({
        assignments: {
          id: 1
        },
        rules: {
          never_drop: [1]
        }
      });
      return strictEqual(ag.hasRules(), true);
    });
    test("#hasRules returns false if the group has empty rules", function() {
      var ag;

      ag = new AssignmentGroup({
        rules: {}
      });
      return strictEqual(ag.hasRules(), false);
    });
    test("#hasRules returns false if the group has no rules", function() {
      var ag;

      ag = new AssignmentGroup;
      return strictEqual(ag.hasRules(), false);
    });
    test("#countRules works for regular rules", function() {
      var ag;

      ag = new AssignmentGroup({
        rules: {
          drop_lowest: 1
        }
      });
      return strictEqual(ag.countRules(), 1);
    });
    test("#countRules works for never drop rules", function() {
      var ag;

      ag = new AssignmentGroup({
        assignments: {
          id: 1
        },
        rules: {
          never_drop: [1]
        }
      });
      return strictEqual(ag.countRules(), 1);
    });
    test("#countRules only counts drop rules for assignments it has", function() {
      var ag;

      ag = new AssignmentGroup({
        assignments: {
          id: 2
        },
        rules: {
          never_drop: [1]
        }
      });
      return strictEqual(ag.countRules(), 0);
    });
    test("#countRules returns false if the group has empty rules", function() {
      var ag;

      ag = new AssignmentGroup({
        rules: {}
      });
      return strictEqual(ag.countRules(), 0);
    });
    test("#countRules returns false if the group has no rules", function() {
      var ag;

      ag = new AssignmentGroup;
      return strictEqual(ag.countRules(), 0);
    });
    module("AssignmentGroup#hasFrozenAssignments");
    return test("returns true if AssignmentGroup has frozen assignments", function() {
      var assignment, group;

      assignment = new Assignment({
        name: 'cheese'
      });
      assignment.set('frozen', [true]);
      group = new AssignmentGroup({
        name: 'taco',
        assignments: [assignment]
      });
      return deepEqual(group.hasFrozenAssignments(), true);
    });
  });

}).call(this);

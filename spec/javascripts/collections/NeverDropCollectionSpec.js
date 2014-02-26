(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'Backbone', 'compiled/collections/NeverDropCollection'], function(_, Backbone, NeverDropCollection) {
    var AssignmentStub, Assignments, _ref, _ref1;

    AssignmentStub = (function(_super) {
      __extends(AssignmentStub, _super);

      function AssignmentStub() {
        this.toView = __bind(this.toView, this);        _ref = AssignmentStub.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      AssignmentStub.prototype.name = function() {
        return this.get('name');
      };

      AssignmentStub.prototype.toView = function() {
        return {
          name: this.get('name'),
          id: this.id
        };
      };

      return AssignmentStub;

    })(Backbone.Model);
    Assignments = (function(_super) {
      __extends(Assignments, _super);

      function Assignments() {
        _ref1 = Assignments.__super__.constructor.apply(this, arguments);
        return _ref1;
      }

      Assignments.prototype.model = AssignmentStub;

      return Assignments;

    })(Backbone.Collection);
    module("NeverDropCollection", {
      setup: function() {
        var i, list, val;

        list = [1, 2, 3, 4, 5];
        this.assignments = new Assignments([]);
        this.assignments.comparator = 'position';
        this.assignments.reset((function() {
          var _i, _len, _results;

          _results = [];
          for (i = _i = 0, _len = list.length; _i < _len; i = ++_i) {
            val = list[i];
            _results.push({
              id: val,
              position: list.length - i,
              name: "Assignment " + val
            });
          }
          return _results;
        })());
        return this.never_drops = new NeverDropCollection([], {
          assignments: this.assignments,
          ag_id: 1
        });
      }
    });
    test("#initialize", function() {
      deepEqual(this.never_drops.assignments, this.assignments);
      return strictEqual(this.never_drops.ag_id, 1);
    });
    test("#toAssignments", function() {
      var expected, output;

      this.never_drops.add({});
      this.never_drops.add({});
      this.never_drops.add({});
      this.never_drops.add({});
      output = this.never_drops.toAssignments(this.never_drops.at(3).get('chosen_id'));
      expected = this.assignments.slice(3).map(function(m) {
        return m.toView();
      });
      return deepEqual(output, expected);
    });
    return test("#findNextAvailable", function() {
      this.never_drops.add({});
      return deepEqual(this.never_drops.findNextAvailable(), this.never_drops.availableValues.get(this.assignments.at(1).id), "finds the available item that has the id of the second assignment");
    });
  });

}).call(this);

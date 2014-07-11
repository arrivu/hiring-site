(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'Backbone', 'compiled/collections/NeverDropCollection', 'compiled/views/assignments/NeverDropCollectionView'], function($, _, Backbone, NeverDropCollection, NeverDropCollectionView) {
    var AssignmentStub, Assignments, addNeverDrop, _ref, _ref1;

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
    module("NeverDropCollectionView", {
      setup: function() {
        var i;

        this.clock = sinon.useFakeTimers();
        this.assignments = new Assignments((function() {
          var _i, _results;

          _results = [];
          for (i = _i = 1; _i <= 3; i = ++_i) {
            _results.push({
              id: i,
              name: "Assignment " + i
            });
          }
          return _results;
        })());
        this.never_drops = new NeverDropCollection([], {
          assignments: this.assignments,
          ag_id: 'new'
        });
        this.view = new NeverDropCollectionView({
          collection: this.never_drops
        });
        return $('#fixtures').empty().append(this.view.render().el);
      },
      teardown: function() {
        return this.clock.restore();
      }
    });
    addNeverDrop = function() {
      return this.never_drops.add({
        id: this.never_drops.size(),
        label_id: 'new'
      });
    };
    test("possibleValues is set to the range of assignment ids", function() {
      return deepEqual(this.never_drops.possibleValues, this.assignments.map(function(a) {
        return a.id;
      }));
    });
    test("adding a NeverDrop to the collection reduces availableValues by one", function() {
      var start_length;

      start_length = this.never_drops.availableValues.length;
      addNeverDrop.call(this);
      return equal(start_length - 1, this.never_drops.availableValues.length);
    });
    test("adding a NeverDrop renders a <select> with the value from the front of the availableValues collection", function() {
      var expected_val, view;

      expected_val = this.never_drops.availableValues.slice(0)[0].id;
      addNeverDrop.call(this);
      this.clock.tick(101);
      view = $('#fixtures').find('select');
      ok(view.length, 'a select was rendered');
      return equal(expected_val, view.val(), 'the selects value is the same as the last available value');
    });
    test("the number of <option>s with the value the same as availableValue should equal the number of selects", function() {
      var available_val;

      addNeverDrop.call(this);
      addNeverDrop.call(this);
      this.clock.tick(101);
      available_val = this.never_drops.availableValues.at(0).id;
      return equal($('#fixtures').find('option[value=' + available_val + ']').length, 2);
    });
    test("removing a NeverDrop from the collection increases availableValues by one", function() {
      var current_size, model;

      addNeverDrop.call(this);
      this.clock.tick(101);
      current_size = this.never_drops.availableValues.length;
      model = this.never_drops.at(0);
      this.never_drops.remove(model);
      return equal(current_size + 1, this.never_drops.availableValues.length);
    });
    test("removing a NeverDrop from the collection removes the view", function() {
      var model, view;

      addNeverDrop.call(this);
      model = this.never_drops.at(0);
      this.never_drops.remove(model);
      this.clock.tick(101);
      view = $('#fixtures').find('select');
      return equal(view.length, 0);
    });
    test("changing a <select> will remove all <option>s with that value from other selects", function() {
      var target_id;

      addNeverDrop.call(this);
      addNeverDrop.call(this);
      target_id = 1;
      this.clock.tick(101);
      ok($('#fixtures').find('option[value=' + target_id + ']').length, 2);
      $('#fixtures').find('select:first').val(target_id).trigger('change');
      this.clock.tick(101);
      ok($('#fixtures').find('option[value=' + target_id + ']').length, 1);
      return ok(this.never_drops.takenValues.find(function(nd) {
        return nd.id === target_id;
      }));
    });
    test("changing a <select> will add all <option>s with the previous value to other selects", function() {
      var change_id, target_id;

      addNeverDrop.call(this);
      addNeverDrop.call(this);
      change_id = 1;
      target_id = 3;
      this.clock.tick(101);
      ok($('#fixtures').find('option[value=' + target_id + ']').length, 1);
      $('#fixtures').find('select:first').val(change_id).trigger('change');
      this.clock.tick(101);
      ok($('#fixtures').find('option[value=' + target_id + ']').length, 2);
      return ok(this.never_drops.availableValues.find(function(nd) {
        return nd.id === target_id;
      }));
    });
    test("resetting NeverDrops with a chosen assignment renders a <span>", function() {
      var target_id;

      target_id = 1;
      this.never_drops.reset([
        {
          id: this.never_drops.length,
          label_id: 'new',
          chosen: 'Assignment 1',
          chosen_id: target_id
        }
      ]);
      this.clock.tick(101);
      ok($('#fixtures').find('span').length, 1);
      return ok(this.never_drops.takenValues.find(function(nd) {
        return nd.id === target_id;
      }));
    });
    test("clicking the remove button, removes a model from the NeverDrop Collection", function() {
      var initial_length;

      addNeverDrop.call(this);
      this.clock.tick(101);
      initial_length = this.never_drops.length;
      $('#fixtures').find('.remove_never_drop').trigger('click');
      this.clock.tick(101);
      return equal(initial_length - 1, this.never_drops.length);
    });
    test("when there are no availableValues, the add assignment link is not rendered", function() {
      addNeverDrop.call(this);
      addNeverDrop.call(this);
      addNeverDrop.call(this);
      this.clock.tick(101);
      return equal($('#fixtures').find('.add_never_drop').length, 0);
    });
    test("when there are no takenValues, the add assignment says 'add an assignment'", function() {
      var text;

      text = $('#fixtures').find('.add_never_drop').text();
      return equal($.trim(text), 'Add an assignment');
    });
    return test("when there is at least one takenValue, the add assignment says 'add another assignment'", function() {
      var text;

      addNeverDrop.call(this);
      this.clock.tick(101);
      text = $('#fixtures').find('.add_never_drop').text();
      return equal($.trim(text), 'Add another assignment');
    });
  });

}).call(this);

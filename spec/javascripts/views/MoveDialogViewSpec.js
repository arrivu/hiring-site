(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'jquery', 'Backbone', 'compiled/views/MoveDialogView', 'helpers/jquery.simulate'], function(_, $, Backbone, MoveDialogView) {
    var AssignmentGroups, AssignmentStub, Assignments, createDialog, genSetup, server, _ref, _ref1, _ref2;

    server = null;
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

      Assignments.prototype.comparator = 'position';

      return Assignments;

    })(Backbone.Collection);
    AssignmentGroups = (function(_super) {
      __extends(AssignmentGroups, _super);

      function AssignmentGroups() {
        _ref2 = AssignmentGroups.__super__.constructor.apply(this, arguments);
        return _ref2;
      }

      AssignmentGroups.prototype.comparator = 'position';

      return AssignmentGroups;

    })(Backbone.Collection);
    genSetup = function() {
      var i;

      this.assignments_1 = new Assignments((function() {
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
      this.assignments_2 = new Assignments((function() {
        var _i, _results;

        _results = [];
        for (i = _i = 5; _i <= 10; i = ++_i) {
          _results.push({
            id: i,
            name: "Assignment " + i
          });
        }
        return _results;
      })());
      return this.assignmentGroups = new AssignmentGroups([
        new Backbone.Model({
          assignments: this.assignments_1,
          id: 1
        }), new Backbone.Model({
          assignments: this.assignments_2,
          id: 2
        })
      ]);
    };
    createDialog = function(hasParentCollection, saveURL) {
      this.model = this.assignments_1.at(0);
      return this.moveDialog = new MoveDialogView({
        model: this.model,
        nested: hasParentCollection ? true : void 0,
        parentCollection: hasParentCollection ? this.assignmentGroups : void 0,
        childKey: 'assignments',
        parentKey: 'assignment_group_id',
        saveURL: saveURL
      });
    };
    module('MoveDialogView', {
      setup: function() {
        genSetup.call(this);
        this.update_spy = sinon.spy(MoveDialogView.prototype, 'updateListView');
        return createDialog.call(this, true);
      },
      teardown: function() {
        this.moveDialog.remove();
        return this.update_spy.restore();
      }
    });
    test('child views don\'t exist on init', function() {
      return ok(!this.moveDialog.listView && !this.moveDialog.parentListView);
    });
    test('#getFormData returns ids', function() {
      var expected;

      this.moveDialog.open();
      expected = this.assignments_1.pluck('id');
      return _.each(this.moveDialog.getFormData(), function(val, ind) {
        return equal(val, expected[ind]);
      });
    });
    test('#getFormData adds model id at end if value is "last"', function() {
      var expected, lastSelect;

      this.moveDialog.open();
      expected = _.pluck(this.assignments_1.slice(1), 'id');
      expected.push(this.assignments_1.at(0).id);
      lastSelect = this.moveDialog.$('select').last();
      lastSelect.find('option').last().prop('selected', true);
      lastSelect.trigger('change');
      return _.each(this.moveDialog.getFormData(), function(val, ind) {
        return equal(val, expected[ind]);
      });
    });
    test('two selects are attached with #attachChildViews', function() {
      this.moveDialog.open();
      return equal(this.moveDialog.$('select').length, 2);
    });
    test('changing the value of the parentList select sets the collection on the listView', function() {
      var firstSelect, initialHTML, options,
        _this = this;

      this.moveDialog.open();
      initialHTML = this.moveDialog.$('select').last().html();
      firstSelect = this.moveDialog.$('select').first();
      firstSelect.find('option').last().prop('selected', true);
      firstSelect.trigger('change');
      ok(this.update_spy.calledOnce);
      notEqual(this.moveDialog.$('select').last().html(), initialHTML);
      options = this.moveDialog.$('select').last().find('option');
      return _.each(options, function(ele, ind) {
        var value;

        value = ele.value;
        if (value !== "last") {
          return equal(value, _this.assignments_2.at(ind).id);
        }
      });
    });
    module('MoveDialogView without a parentCollection', {
      setup: function() {
        genSetup.call(this);
        return createDialog.call(this, false);
      },
      teardown: function() {
        return this.moveDialog.remove();
      }
    });
    test('only one select is attached with #attachChildViews', function() {
      this.moveDialog.open();
      return equal(this.moveDialog.$('select').length, 1);
    });
    module('MoveDialogView save and save success', {
      setup: function() {
        genSetup.call(this);
        server = sinon.fakeServer.create();
        this.sort_spy = sinon.spy(Assignments.prototype, 'sort');
        return this.reset_spy = sinon.spy(Assignments.prototype, 'reset');
      },
      teardown: function() {
        _.each(server.requests, function() {
          return server.respond();
        });
        server.restore();
        this.sort_spy.restore();
        this.reset_spy.restore();
        return this.moveDialog.remove();
      }
    });
    test('@saveURL as a string', function() {
      var saveURL;

      saveURL = "/test";
      createDialog.call(this, true, saveURL);
      this.moveDialog.open();
      this.moveDialog.submit();
      return equal(server.requests[0].url, saveURL);
    });
    test('@saveURL as a function', function() {
      var saveURL;

      saveURL = function() {
        return "/test/" + this.childKey;
      };
      createDialog.call(this, true, saveURL);
      this.moveDialog.open();
      this.moveDialog.submit();
      return equal(server.requests[0].url, saveURL.call(this.moveDialog));
    });
    test('collection #sort and #reset are called on success', function() {
      var saveURL;

      saveURL = "/test";
      createDialog.call(this, true, saveURL);
      this.moveDialog.open();
      this.moveDialog.submit();
      server.respond('POST', '/test', [
        200, {
          'Content-Type': 'application/json'
        }, JSON.stringify([2, 1, 3])
      ]);
      ok(this.sort_spy.called);
      return ok(this.reset_spy.called);
    });
    return test('parentKey value on the model is updated on save success when the model moves collections', function() {
      var firstSelect, saveURL;

      saveURL = "/test";
      createDialog.call(this, true, saveURL);
      ok(!this.model.has('assignment_group_id'));
      this.moveDialog.open();
      firstSelect = this.moveDialog.$('select').first();
      firstSelect.find('option').last().prop('selected', true);
      firstSelect.trigger('change');
      this.moveDialog.submit();
      server.respond('POST', '/test', [
        200, {
          'Content-Type': 'application/json'
        }, JSON.stringify([2, 1, 3])
      ]);
      return ok(this.model.has('assignment_group_id'));
    });
  });

}).call(this);

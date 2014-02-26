(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'jquery', 'Backbone', 'compiled/views/MoveDialogSelect', 'helpers/jquery.simulate'], function(_, $, Backbone, MoveDialogSelect) {
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
    module('MoveDialogSelect', {
      setup: function() {
        var i;

        this.set_coll_spy = sinon.spy(MoveDialogSelect.prototype, 'setCollection');
        this.render_spy = sinon.spy(MoveDialogSelect.prototype, 'render');
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
        return this.view = new MoveDialogSelect({
          model: this.assignments.at(0),
          excludeModel: true,
          lastList: true
        });
      },
      teardown: function() {
        this.set_coll_spy.restore();
        return this.render_spy.restore();
      }
    });
    test('#initialize, if a collection is not passed the model\'s collection will be used for @collection', function() {
      return deepEqual(this.view.model.collection, this.assignments);
    });
    test('if @excludeModel = true, there won\'t be a corresponding <option> for the model', function() {
      var option_with_model_id, options,
        _this = this;

      options = $(this.view.render().el).find('option');
      equal(options.length, this.assignments.length);
      option_with_model_id = _.any(options, function(ele, ind) {
        var value;

        value = ele.value;
        return (value != null) && value === _this.assignments.at(0).id;
      });
      return ok(!option_with_model_id);
    });
    test('#value get the current value of the select', function() {
      $(this.view.render().el).find('option').last().prop('selected', true);
      return equal(this.view.value(), 'last');
    });
    test('#getLabelText returns "Place before:" by default', function() {
      return equal($.trim($(this.view.render().el).find('label').text()), "Place before:");
    });
    test('#getLabelText returns the passed value for @labelText', function() {
      var label, view;

      label = 'hello world';
      view = new MoveDialogSelect({
        model: this.assignments.at(0),
        labelText: label
      });
      return equal($.trim($(view.render().el).find('label').text()), label);
    });
    test('#setCollection returns `undefined` if no argument is passed', function() {
      this.view.setCollection();
      return ok(this.set_coll_spy.returned(void 0));
    });
    test('#setCollection changes the value of @collection', function() {
      var i, other_assignments;

      other_assignments = new Assignments((function() {
        var _i, _results;

        _results = [];
        for (i = _i = 5; _i <= 9; i = ++_i) {
          _results.push({
            id: i,
            name: "Assignment " + i
          });
        }
        return _results;
      })());
      this.view.setCollection(other_assignments);
      deepEqual(this.view.collection, other_assignments);
      return ok(this.render_spy.called);
    });
    return test('#toJSON returns an object that can be used for rendering the select', function() {
      var expected,
        _this = this;

      expected = this.view.model.toView();
      expected.items = this.view.model.collection.reject(function(m) {
        return m.id === _this.view.model.id;
      }).map(function(m) {
        return m.toView();
      });
      expected.labelText = 'Place before:';
      expected.lastList = true;
      return deepEqual(this.view.toJSON(), expected);
    });
  });

}).call(this);

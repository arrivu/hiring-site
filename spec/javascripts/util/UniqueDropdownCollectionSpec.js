(function() {
  define(['compiled/util/UniqueDropdownCollection', 'Backbone', 'underscore'], function(UniqueDropdownCollection, Backbone, _) {
    module("UniqueDropdownCollection", {
      setup: function() {
        var i;

        this.records = (function() {
          var _i, _results;

          _results = [];
          for (i = _i = 1; _i <= 3; i = ++_i) {
            _results.push(new Backbone.Model({
              id: i,
              state: i.toString()
            }));
          }
          return _results;
        })();
        return this.coll = new UniqueDropdownCollection(this.records, {
          propertyName: 'state',
          possibleValues: _.map([1, 2, 3, 4], function(i) {
            return i.toString();
          })
        });
      }
    });
    test("#intialize", function() {
      ok(this.coll.length === this.records.length, 'stores all the records');
      equal(this.coll.takenValues.length, 3);
      equal(this.coll.availableValues.length, 1);
      return ok(this.coll.availableValues instanceof Backbone.Collection);
    });
    test("updates available/taken when models change", function() {
      this.coll.availableValues.on('remove', function(model) {
        return strictEqual(model.get('value'), '4');
      });
      this.coll.availableValues.on('add', function(model) {
        return strictEqual(model.get('value'), '1');
      });
      this.coll.takenValues.on('remove', function(model) {
        return strictEqual(model.get('value'), '1');
      });
      this.coll.takenValues.on('add', function(model) {
        return strictEqual(model.get('value'), '4');
      });
      return this.records[0].set('state', '4');
    });
    test("removing a model updates the available/taken values", function() {
      this.coll.availableValues.on('add', function(model) {
        return strictEqual(model.get('value'), '1');
      });
      this.coll.takenValues.on('remove', function(model) {
        return strictEqual(model.get('value'), '1');
      });
      return this.coll.remove(this.coll.get(1));
    });
    test("overrides add to munge params with an available value", function() {
      this.coll.model = Backbone.Model;
      this.coll.add({});
      equal(this.coll.availableValues.length, 0);
      equal(this.coll.takenValues.length, 4);
      ok(this.coll.takenValues.get('4') instanceof Backbone.Model);
      return equal(this.coll.at(this.coll.length - 1).get('state'), 4);
    });
    test("add should take the value from the front of the available values collection", function() {
      var first_avail;

      this.coll.remove(this.coll.at(0));
      first_avail = this.coll.availableValues.at(0).get('state');
      this.coll.availableValues.on('remove', function(model) {
        return strictEqual(model.get('state'), first_avail);
      });
      this.coll.model = Backbone.Model;
      return this.coll.add({});
    });
    module("UniqueDropdownCollection, lazy setup", {
      setup: function() {
        var i;

        this.records = (function() {
          var _i, _results;

          _results = [];
          for (i = _i = 1; _i <= 3; i = ++_i) {
            _results.push(new Backbone.Model({
              id: i,
              state: i.toString()
            }));
          }
          return _results;
        })();
        return this.coll = new UniqueDropdownCollection([], {
          propertyName: 'state',
          possibleValues: _.map([1, 2, 3, 4], function(i) {
            return i.toString();
          })
        });
      }
    });
    return test("reset of collection recalculates availableValues", function() {
      equal(this.coll.availableValues.length, 4, 'has the 4 default items on init');
      this.coll.reset(this.records);
      return equal(this.coll.availableValues.length, 1, '`availableValues` is recalculated on reset');
    });
  });

}).call(this);

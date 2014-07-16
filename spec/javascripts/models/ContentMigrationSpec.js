(function() {
  define(['Backbone', 'compiled/models/ContentMigration', 'compiled/collections/DaySubstitutionCollection'], function(Backbone, ContentMigration, DaySubstitutionCollection) {
    module('ContentMigration', {
      setup: function() {
        return this.model = new ContentMigration({
          foo: 'bar'
        });
      }
    });
    test('dynamicDefaults are set when initializing the model', function() {
      var model;

      model = new ContentMigration({
        foo: 'bar',
        cat: 'hat'
      });
      equal(model.dynamicDefaults.foo, 'bar', 'bar was set');
      return equal(model.dynamicDefaults.cat, 'hat', 'hat was set');
    });
    test('dynamicDefaults is stored on the instance, not all classes', function() {
      var model1, model2;

      model1 = new ContentMigration({
        foo: 'bar'
      });
      model2 = new ContentMigration({
        cat: 'hat'
      });
      equal(model2.dynamicDefaults.foo, void 0);
      return equal(model1.dynamicDefaults.cat, void 0);
    });
    test('resetModel adds restores dynamic defaults', function() {
      this.model.clear();
      equal(this.model.get('foo'), void 0, 'Model is clear');
      this.model.resetModel();
      return equal(this.model.get('foo'), 'bar', 'Model defaults are now reset');
    });
    test('resetModel removes non initialized attributes', function() {
      this.model.set('cat', 'hat');
      this.model.resetModel();
      return equal(this.model.get('cat'), void 0, 'Non initialized attributes removed');
    });
    test('resetModel resets all collections that were defined in the dynamicDefaults', function() {
      var collection, model;

      collection = new Backbone.Collection([new Backbone.Model, new Backbone.Model, new Backbone.Model]);
      model = new ContentMigration({
        someCollection: collection
      });
      equal(model.get('someCollection').length, 3, 'There are 3 collections in the model');
      model.resetModel();
      return equal(model.get('someCollection').length, 0, 'All models in the collection were cleared');
    });
    test('toJSON adds a date_shift_options namespace if non exists', function() {
      var json;

      json = this.model.toJSON();
      return equal(typeof json.date_shift_options, 'object', 'adds date_shift_options');
    });
    test('adds daySubsitution JSON to day_subsitutions namespace if daySubCollection exists', function() {
      var collection, collectionJSON, json;

      collection = new DaySubstitutionCollection({
        bar: 'baz'
      });
      this.model.daySubCollection = collection;
      collectionJSON = collection.toJSON();
      json = this.model.toJSON();
      return deepEqual(json.date_shift_options.day_substitutions, collectionJSON, 'day subsitution json added from collection');
    });
    return test('toJSON keeps all date_shift_options when adding new day_substitutions', function() {
      var collection, dsOptions, json;

      dsOptions = {
        bar: 'baz'
      };
      collection = new DaySubstitutionCollection;
      this.model.daySubCollection = collection;
      this.model.set('date_shift_options', {
        bar: 'baz'
      });
      json = this.model.toJSON();
      return equal(json.date_shift_options.bar, 'baz', 'Keeps date_shift_options');
    });
  });

}).call(this);

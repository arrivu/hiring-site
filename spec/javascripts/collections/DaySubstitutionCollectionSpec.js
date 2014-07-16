(function() {
  define(['compiled/collections/DaySubstitutionCollection'], function(DaySubCollection) {
    return module('DaySubstitutionCollection', test('toJSON contains nested day_substitution objects', function() {
      var collection, json;

      collection = new DaySubCollection;
      collection.add({
        one: 'bar'
      });
      collection.add({
        two: 'baz'
      });
      json = collection.toJSON();
      equal(json.one, 'bar', 'nested one correctly');
      return equal(json.two, 'baz', 'nexted two correctly');
    }));
  });

}).call(this);

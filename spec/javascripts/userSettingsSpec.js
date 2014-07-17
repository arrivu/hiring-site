(function() {
  require(['compiled/userSettings'], function(userSettings) {
    var globalObj;

    globalObj = this;
    module('UserSettings', {
      setup: function() {
        this._ENV = globalObj.ENV;
        return globalObj.ENV = {
          current_user_id: 1,
          context_asset_string: 'course_1'
        };
      },
      teardown: function() {
        return globalObj.ENV = this._ENV;
      }
    });
    test('`get` should return what was `set`', function() {
      userSettings.set('foo', 'bar');
      return equal(userSettings.get('foo'), 'bar');
    });
    test('it should strigify/parse JSON', function() {
      var testObject;

      testObject = {
        foo: [1, 2, 3],
        bar: 'true',
        baz: true
      };
      userSettings.set('foo', testObject);
      return deepEqual(userSettings.get('foo'), testObject);
    });
    test('it should store different things for different users', function() {
      userSettings.set('foo', 1);
      ENV.current_user_id = 2;
      userSettings.set('foo', 2);
      equal(userSettings.get('foo'), 2);
      ENV.current_user_id = 1;
      return equal(userSettings.get('foo'), 1);
    });
    return test('it should store different things for different contexts', function() {
      userSettings.contextSet('foo', 1);
      ENV.context_asset_string = 'course_2';
      userSettings.contextSet('foo', 2);
      equal(userSettings.contextGet('foo'), 2);
      ENV.context_asset_string = 'course_1';
      return equal(userSettings.contextGet('foo'), 1);
    });
  });

}).call(this);

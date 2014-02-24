(function() {
  define(['compiled/util/mixin'], function(mixin) {
    module('mixin');
    return test('merges objects without blowing away events or defaults', 4, function() {
      var expectedDefaults, expectedEvents, mixin1, mixin2, obj;

      mixin1 = {
        events: {
          'click .foo': 'foo'
        },
        defaults: {
          foo: 'bar'
        },
        foo: sinon.spy()
      };
      mixin2 = {
        events: {
          'click .bar': 'bar'
        },
        defaults: {
          baz: 'qux'
        },
        bar: sinon.spy()
      };
      obj = mixin({}, mixin1, mixin2);
      expectedEvents = {
        'click .foo': 'foo',
        'click .bar': 'bar'
      };
      expectedDefaults = {
        foo: 'bar',
        baz: 'qux'
      };
      deepEqual(obj.events, expectedEvents, 'events merged properly');
      deepEqual(obj.defaults, expectedDefaults, 'defaults merged properly');
      obj.foo();
      ok(obj.foo.calledOnce);
      obj.bar();
      return ok(obj.bar.calledOnce);
    });
  });

}).call(this);

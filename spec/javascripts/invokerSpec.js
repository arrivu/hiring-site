(function() {
  define(['compiled/util/invoker'], function(invoker) {
    var obj,
      _this = this;

    obj = invoker({
      one: function() {
        return 1;
      },
      noMethod: function() {
        return 'noMethod';
      }
    });
    module('Invoker');
    test('should call a method with invoke', function() {
      var result;

      result = obj.invoke('one');
      return equal(result, 1);
    });
    return test("should call noMethod when invoked method doesn't exist", function() {
      var result;

      result = obj.invoke('non-existent');
      return equal(result, 'noMethod');
    });
  });

}).call(this);

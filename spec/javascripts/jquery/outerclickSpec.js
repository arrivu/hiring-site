(function() {
  define(['jquery', 'compiled/jquery/outerclick'], function($) {
    module('outerclick');
    return test('should work', function() {
      var $doc, $foo, handler;

      handler = sinon.spy();
      $doc = $(document);
      $foo = $('<b>hello <i>world</i></b>').appendTo($doc);
      $foo.on('outerclick', handler);
      $foo.click();
      $foo.find('i').click();
      ok(!handler.called);
      $doc.click();
      ok(handler.calledOnce);
      return $foo.remove();
    });
  });

}).call(this);

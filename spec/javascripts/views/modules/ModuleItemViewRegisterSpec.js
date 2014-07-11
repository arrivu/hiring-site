(function() {
  define(['underscore', 'Backbone', 'compiled/views/modules/ModuleItemViewRegister'], function(_, Backbone, ModuleItemViewRegister) {
    module('MIVR: Register');
    return test('allows you to render view instances with a look up key', function() {
      var testView;

      testView = new Backbone.View;
      ModuleItemViewRegister.register({
        key: 'testView',
        view: testView
      });
      return deepEqual(ModuleItemViewRegister.views['testView'], testView, "Adds view to the register");
    });
  });

}).call(this);

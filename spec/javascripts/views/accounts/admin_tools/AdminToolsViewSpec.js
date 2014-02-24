(function() {
  define(['Backbone', 'jquery', 'compiled/views/accounts/admin_tools/AdminToolsView'], function(Backbone, $, AdminToolsView) {
    module('AdminToolsViewSpec', {
      setup: function() {
        this.admin_tools_view = new AdminToolsView({
          restoreContentPaneView: new Backbone.View,
          messageContentPaneView: new Backbone.View,
          tabs: {
            courseRestore: true,
            viewMessages: true
          }
        });
        return $('#fixtures').append(this.admin_tools_view.render().el);
      },
      teardown: function() {
        return this.admin_tools_view.remove();
      }
    });
    return test("creates a new jquery tabs", function() {
      return ok(this.admin_tools_view.$adminToolsTabs.data('tabs'), "There should be 2 tabs initialized");
    });
  });

}).call(this);

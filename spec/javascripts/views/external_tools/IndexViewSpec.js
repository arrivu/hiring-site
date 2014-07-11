(function() {
  define(['Backbone', 'jquery', 'jst/ExternalTools/AppCenterView', 'compiled/views/ExternalTools/IndexView', 'compiled/collections/ExternalToolCollection', 'compiled/collections/PaginatedCollection', 'compiled/views/PaginatedCollectionView', 'compiled/views/ExternalTools/ExternalToolsCollectionView', 'compiled/views/ExternalTools/AppThumbnailView', 'helpers/assertions'], function(Backbone, $, AppCenterTemplate, IndexView, ExternalToolCollection, PaginatedCollection, PaginatedCollectionView, ExternalToolsCollectionView, AppThumbnailView, assert) {
    var appCenterView, apps, externalTools, externalToolsCollectionView, view;

    externalTools = null;
    apps = null;
    appCenterView = null;
    externalToolsCollectionView = null;
    view = null;
    module("ExternalTools", {
      setup: function() {
        externalTools = new ExternalToolCollection;
        apps = new PaginatedCollection;
        apps.resourceName = 'app_center/apps';
        appCenterView = new PaginatedCollectionView({
          template: AppCenterTemplate,
          itemView: AppThumbnailView,
          collection: apps
        });
        externalToolsCollectionView = new ExternalToolsCollectionView({
          collection: externalTools
        });
        view = new IndexView({
          externalToolsView: externalToolsCollectionView,
          appCenterView: appCenterView,
          appCenterEnabled: true
        });
        $('#fixtures').append(view.$el);
        return view.render();
      },
      teardown: function() {
        return view.remove();
      }
    });
    return test('IndexView: afterRender', function() {
      return assert.isVisible($('.app_center'));
    });
  });

}).call(this);

(function() {
  define(['jquery', 'Backbone', 'compiled/views/modules/ModuleCollectionView'], function($, Backbone, ModuleCollectionView) {
    module('ModuleCollectionView');
    return test("adds editable class to the div of the collection view", function() {
      var moduleCollectionView;

      moduleCollectionView = new ModuleCollectionView({
        collection: new Backbone.Collection,
        editable: true
      });
      return ok(moduleCollectionView.render().$el.find('.editable').length === 1, "has a css class of editable");
    });
  });

}).call(this);

(function() {
  define(['jquery', 'compiled/views/groups/manage/GroupCategoriesView', 'compiled/collections/GroupCategoryCollection', 'compiled/models/GroupCategory', 'compiled/views/groups/manage/GroupCategoryView', 'helpers/fakeENV'], function($, GroupCategoriesView, GroupCategoryCollection, GroupCategory) {
    var categories, clock, view;

    clock = null;
    view = null;
    categories = null;
    module('GroupCategoriesView', {
      setup: function() {
        ENV.group_categories_url = '/api/v1/courses/1/group_categories';
        clock = sinon.useFakeTimers();
        categories = new GroupCategoryCollection([
          {
            id: 1,
            name: "group set 1"
          }, {
            id: 2,
            name: "group set 2"
          }
        ]);
        view = new GroupCategoriesView({
          collection: categories
        });
        view.render();
        return view.$el.appendTo($(document.body));
      },
      teardown: function() {
        clock.restore();
        view.remove();
        return $('.group_categories_area').remove();
      }
    });
    test('render tab and panel elements', function() {
      equal(view.$el.find('.collectionViewItems > li').length, 2);
      equal(view.$el.find('#tab-1').length, 1);
      return equal(view.$el.find('#tab-2').length, 1);
    });
    test('adding new GroupCategory should display new tab and panel', function() {
      categories.add(new GroupCategory({
        id: 3,
        name: 'Newly Added'
      }));
      equal(view.$el.find('.collectionViewItems > li').length, 3);
      return equal(view.$el.find('#tab-3').length, 1);
    });
    test('removing GroupCategory should remove tab and panel', function() {
      categories.remove(categories.models[0]);
      equal(view.$el.find('.collectionViewItems > li').length, 1);
      equal(view.$el.find('#tab-1').length, 0);
      categories.remove(categories.models[0]);
      equal(view.$el.find('.collectionViewItems > li').length, 0);
      return equal(view.$el.find('#tab-2').length, 0);
    });
    return test('tab panel content should be loaded when tab is activated', function() {
      equal($('#tab-2').children().length, 0);
      view.$el.find('.group-category-tab-link:last').click();
      return ok($('#tab-2').children().length > 0);
    });
  });

}).call(this);

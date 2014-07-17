(function() {
  define(['jquery', 'compiled/views/ExternalTools/EditView'], function($, EditView) {
    module('ExternalTools', {
      setup: function() {
        this.view = new EditView();
        return this.view.render();
      },
      teardown: function() {
        return this.view.$el.dialog('close');
      }
    });
    test('EditView: adds errors', 6, function() {
      this.view.addError(this.view.$('input').first(), 'Wrong!');
      equal($('.help-inline').size(), 1, 'Inline help text appears');
      equal($('.error').size(), 1, 'Missing required field appear with red borders');
      ok($(".help-inline:contains('Wrong!')").is(':visible'));
      this.view.addError(this.view.$('input').last(), 'Also Wrong...');
      equal($('.help-inline').size(), 2, 'Inline help text appears');
      equal($('.error').size(), 2, 'Missing required field appear with red borders');
      return ok($(".help-inline:contains('Also Wrong...')").is(':visible'));
    });
    return test('EditView: removes all errors', 2, function() {
      this.view.addError(this.view.$('input').first(), 'Wrong!');
      this.view.addError(this.view.$('input').last(), 'Also Wrong...');
      equal($('.help-inline').size(), 2, 'Two errors are displayed');
      this.view.removeErrors();
      return equal($('.help-inline').size(), 0, 'Zero errors are displayed (after "removeErrors()")');
    });
  });

}).call(this);

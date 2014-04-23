(function() {
  define(['compiled/views/content_migrations/ProgressStatusView', 'compiled/models/ProgressingContentMigration'], function(ProgressStatusView, ProgressingModel) {
    module('ProgressStatusViewSpec', {
      setup: function() {
        this.progressingModel = new ProgressingModel;
        this.psv = new ProgressStatusView({
          model: this.progressingModel
        });
        return this.$fixtures = $('#fixtures');
      },
      teardown: function() {
        return this.psv.remove();
      }
    });
    test('displays progress workflow_state when migrations workflow_state is running', function() {
      this.progressingModel.set('workflow_state', 'running');
      this.progressingModel.progressModel.set('workflow_state', 'foo');
      this.$fixtures.append(this.psv.render().el);
      return equal(this.psv.$el.find('.label').text(), 'Foo', "Displays correct workflow state");
    });
    test('displays migration workflow_state when migrations workflow_state is not running', function() {
      this.progressingModel.set('workflow_state', 'some_not_running_state');
      this.$fixtures.append(this.psv.render().el);
      return equal(this.psv.$el.find('.label').text(), 'Some not running state', "Displays correct workflow state");
    });
    test('adds label-success class to status when status is complete', function() {
      this.progressingModel.set('workflow_state', 'complete');
      this.$fixtures.append(this.psv.render().el);
      return ok(this.psv.$el.find('.label-success'), "Adds the label-success class");
    });
    test('adds label-important class to status when status is failed', function() {
      this.progressingModel.set('workflow_state', 'failed');
      this.$fixtures.append(this.psv.render().el);
      return ok(this.psv.$el.find('.label-important'), "Adds the label-important class");
    });
    return test('adds label-info class to status when status is running', function() {
      this.progressingModel.set('workflow_state', 'running');
      this.progressingModel.progressModel.set('workflow_state', 'running');
      this.$fixtures.append(this.psv.render().el);
      return ok(this.psv.$el.find('.label-info'), "Adds the label-info class");
    });
  });

}).call(this);

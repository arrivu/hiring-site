(function() {
  define(['compiled/views/assignments/SpeedgraderLinkView', 'compiled/models/Assignment', 'jquery'], function(SpeedgraderLinkView, Assignment, $) {
    module("SpeedgraderLinkView", {
      setup: function() {
        this.model = new Assignment({
          published: false
        });
        $('#fixtures').html("<a href=\"#\" id=\"assignment-speedgrader-link\" class=\"hidden\"></a>");
        this.view = new SpeedgraderLinkView({
          model: this.model,
          el: $('#fixtures').find('#assignment-speedgrader-link')
        });
        return this.view.render();
      },
      teardown: function() {
        this.view.remove();
        return $('#fixtures').empty();
      }
    });
    return test("#toggleSpeedgraderLink toggles visibility of speedgrader link on change", function() {
      this.model.set('published', true);
      ok(!this.view.$el.hasClass('hidden'));
      this.model.set('published', false);
      return ok(this.view.$el.hasClass('hidden'));
    });
  });

}).call(this);

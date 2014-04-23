(function() {
  define(['Backbone', 'compiled/views/VddTooltipView', 'compiled/models/Assignment', 'jquery', 'helpers/jquery.simulate'], function(Backbone, VddTooltipView, Assignment, $) {
    module('VddTooltipView', {
      setup: function() {
        this.model = new Assignment({
          id: 1,
          html_url: 'http://example.com'
        });
        return this.tooltipView = new VddTooltipView({
          model: this.model
        });
      }
    });
    test('initializes json variables', function() {
      var json;

      this.tooltipView.render();
      json = this.tooltipView.toJSON();
      equal(json['selector'], "1");
      equal(json['linkHref'], "http://example.com");
      return deepEqual(json['allDates'], []);
    });
    return test('initializes tooltip', function() {
      sinon.spy($.fn, "tooltip");
      this.tooltipView.render();
      ok($.fn.tooltip.called);
      return $.fn.tooltip.restore();
    });
  });

}).call(this);

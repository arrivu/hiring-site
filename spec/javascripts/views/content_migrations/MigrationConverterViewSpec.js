(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['Backbone', 'compiled/views/content_migrations/MigrationConverterView'], function(Backbone, MigrationConverterView) {
    var SomeBackboneView, _ref;

    SomeBackboneView = (function(_super) {
      __extends(SomeBackboneView, _super);

      function SomeBackboneView() {
        _ref = SomeBackboneView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      SomeBackboneView.prototype.className = 'someViewRendered';

      SomeBackboneView.prototype.template = function() {
        return '<div id="rendered">Rendered</div>';
      };

      return SomeBackboneView;

    })(Backbone.View);
    module('MigrationConverterView', {
      setup: function() {
        this.clock = sinon.useFakeTimers();
        this.migrationConverterView = new MigrationConverterView({
          selectOptions: [
            {
              id: 'some_converter',
              label: 'Some Converter'
            }
          ],
          progressView: new Backbone.View
        });
        return $('#fixtures').append(this.migrationConverterView.render().el);
      },
      teardown: function() {
        this.clock.restore();
        return this.migrationConverterView.remove();
      }
    });
    test("renders a backbone view into it's main view container", 1, function() {
      var subView,
        _this = this;

      subView = new SomeBackboneView;
      this.migrationConverterView.on('converterRendered', function() {
        return ok(_this.migrationConverterView.$el.find('#converter #rendered').length > 0, "Rendered a sub view");
      });
      this.migrationConverterView.renderConverter(subView);
      return this.clock.tick(15);
    });
    return test("trigger reset event when no subView is passed in to render", 1, function() {
      this.migrationConverterView.on('converterReset', function() {
        return ok(true, "converterReset was called");
      });
      return this.migrationConverterView.renderConverter();
    });
  });

}).call(this);

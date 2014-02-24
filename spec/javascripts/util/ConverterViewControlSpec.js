(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['Backbone', 'underscore', 'compiled/views/content_migrations/ConverterViewControl'], function(Backbone, _, ConverterViewControl) {
    var BackboneSubView, ParentView, _ref, _ref1;

    BackboneSubView = (function(_super) {
      __extends(BackboneSubView, _super);

      function BackboneSubView() {
        _ref = BackboneSubView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      BackboneSubView.prototype.template = function() {
        return "<div>Random Backbone View</div>";
      };

      return BackboneSubView;

    })(Backbone.View);
    ParentView = (function(_super) {
      __extends(ParentView, _super);

      function ParentView() {
        _ref1 = ParentView.__super__.constructor.apply(this, arguments);
        return _ref1;
      }

      ParentView.prototype.template = function() {
        return "<div>Random Backbone View</div>";
      };

      return ParentView;

    })(Backbone.View);
    module('ConverterViewControlSpec', {
      teardown: function() {
        return ConverterViewControl.resetControl();
      }
    });
    test('registering a view adds the view to the register list', function() {
      ConverterViewControl.register({
        value: 'backbone_view',
        view: new BackboneSubView
      });
      return equal(ConverterViewControl.registeredViews.length, 1, "Register the view in the register list");
    });
    test('before registering a view subscribed is false', function() {
      return equal(ConverterViewControl.subscribed, false, "Subscribed is set to faults by default");
    });
    test('after registering a view subscribed is true', function() {
      ConverterViewControl.register({
        value: 'backbone_view',
        view: new BackboneSubView
      });
      return equal(ConverterViewControl.subscribed, true, "Subscribed is set to true after registering a view");
    });
    test('resetControl sets subscribed to false if it was true', function() {
      ConverterViewControl.subscribed = true;
      ConverterViewControl.resetControl();
      return equal(ConverterViewControl.subscribed, false, "resetControl sets subscribed to false");
    });
    return test('resetControl empties registeredViews list', function() {
      ConverterViewControl.register({
        value: 'backbone_view',
        view: new BackboneSubView
      });
      equal(ConverterViewControl.registeredViews.length, 1);
      ConverterViewControl.resetControl();
      return equal(ConverterViewControl.registeredViews.length, 0, "Clears the registeredViews");
    });
  });

}).call(this);

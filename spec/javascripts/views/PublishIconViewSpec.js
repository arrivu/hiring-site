(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['Backbone', 'compiled/views/PublishIconView', 'jquery', 'helpers/jquery.simulate'], function(Backbone, PublishIconView, $) {
    module('PublishIconView', {
      setup: function() {
        var Publishable, _ref;

        this.publishable = Publishable = (function(_super) {
          __extends(Publishable, _super);

          function Publishable() {
            _ref = Publishable.__super__.constructor.apply(this, arguments);
            return _ref;
          }

          Publishable.prototype.defaults = {
            'published': false,
            'publishable': true
          };

          Publishable.prototype.publish = function() {
            this.set("published", true);
            return $.Deferred().resolve();
          };

          Publishable.prototype.unpublish = function() {
            this.set("published", false);
            return $.Deferred().resolve();
          };

          Publishable.prototype.disabledMessage = function() {
            return "can't unpublish";
          };

          return Publishable;

        })(Backbone.Model);
        this.publish = new Publishable({
          published: false,
          publishable: true
        });
        this.published = new Publishable({
          published: true,
          publishable: true
        });
        return this.disabled = new Publishable({
          published: true,
          publishable: false
        });
      }
    });
    test('initialize publish', function() {
      var btnView;

      btnView = new PublishIconView({
        model: this.publish
      }).render();
      ok(btnView.isPublish());
      equal(btnView.$text.html().match(/Publish/).length, 1);
      return ok(!btnView.$text.html().match(/Published/));
    });
    test('initialize publish adds tooltip', function() {
      var btnView;

      btnView = new PublishIconView({
        model: this.publish
      }).render();
      return equal(btnView.$el.attr("data-tooltip"), "");
    });
    test('initialize published', function() {
      var btnView;

      btnView = new PublishIconView({
        model: this.published
      }).render();
      ok(btnView.isPublished());
      return equal(btnView.$text.html().match(/Published/).length, 1);
    });
    test('initialize published adds tooltip', function() {
      var btnView;

      btnView = new PublishIconView({
        model: this.published
      }).render();
      return equal(btnView.$el.attr("data-tooltip"), "");
    });
    test('initialize disabled published', function() {
      var btnView;

      btnView = new PublishIconView({
        model: this.disabled
      }).render();
      ok(btnView.isPublished());
      ok(btnView.isDisabled());
      return equal(btnView.$text.html().match(/Published/).length, 1);
    });
    return test('initialize disabled adds tooltip', function() {
      var btnView;

      btnView = new PublishIconView({
        model: this.disabled
      }).render();
      return equal(btnView.$el.attr("data-tooltip"), "");
    });
  });

}).call(this);

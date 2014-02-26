(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['Backbone', 'compiled/views/PublishButtonView', 'jquery', 'helpers/jquery.simulate'], function(Backbone, PublishButtonView, $) {
    module('PublishButtonView', {
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

      btnView = new PublishButtonView({
        model: this.publish
      }).render();
      ok(btnView.isPublish());
      equal(btnView.$text.html().match(/Publish/).length, 1);
      ok(!btnView.$text.html().match(/Published/));
      equal(btnView.$el.html().match(/<span class="desc/).length, 1);
      return equal(btnView.$el.html().match(/Unpublished/).length, 1);
    });
    test('initialize published', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.published
      }).render();
      ok(btnView.isPublished());
      equal(btnView.$text.html().match(/Published/).length, 1);
      equal(btnView.$el.html().match(/<span class="desc/).length, 1);
      return equal(btnView.$el.html().match(/Published/).length, 1);
    });
    test('initialize disabled published', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.disabled
      }).render();
      ok(btnView.isPublished());
      ok(btnView.isDisabled());
      equal(btnView.$text.html().match(/Published/).length, 1);
      equal(btnView.$el.html().match(/<span class="desc/).length, 1);
      return equal(btnView.$el.html().match(/can't unpublish/).length, 1);
    });
    test('disable should add disabled state', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.publish
      }).render();
      ok(!btnView.isDisabled());
      btnView.disable();
      return ok(btnView.isDisabled());
    });
    test('enable should remove disabled state', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.publish
      }).render();
      btnView.disable();
      ok(btnView.isDisabled());
      btnView.enable();
      return ok(!btnView.isDisabled());
    });
    test('reset should disable states', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.publish
      }).render();
      btnView.reset();
      ok(!btnView.isPublish());
      ok(!btnView.isPublished());
      return ok(!btnView.isUnpublish());
    });
    test('mouseenter publish button should remain publish button', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.publish
      }).render();
      btnView.$el.trigger('mouseenter');
      return ok(btnView.isPublish());
    });
    test('mouseenter publish button should not change text or icon', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.publish
      }).render();
      btnView.$el.trigger('mouseenter');
      equal(btnView.$text.html().match(/Publish/).length, 1);
      return ok(!btnView.$text.html().match(/Published/));
    });
    test('mouseenter published button should remove published state', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.published
      }).render();
      btnView.$el.trigger('mouseenter');
      return ok(!btnView.isPublished());
    });
    test('mouseenter published button should add add unpublish state', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.published
      }).render();
      btnView.$el.trigger('mouseenter');
      return ok(btnView.isUnpublish());
    });
    test('mouseenter published button should change icon and text', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.published
      }).render();
      btnView.$el.trigger('mouseenter');
      return equal(btnView.$text.html().match(/Unpublish/).length, 1);
    });
    test('mouseenter disabled published button should keep published state', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.disabled
      }).render();
      btnView.$el.trigger('mouseenter');
      return ok(btnView.isPublished());
    });
    test('mouseenter disabled published button should not change text or icon', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.disabled
      }).render();
      return equal(btnView.$text.html().match(/Published/).length, 1);
    });
    test('mouseleave published button should add published state', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.published
      }).render();
      btnView.$el.trigger('mouseenter');
      btnView.$el.trigger('mouseleave');
      return ok(btnView.isPublished());
    });
    test('mouseleave published button should remove unpublish state', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.published
      }).render();
      btnView.$el.trigger('mouseenter');
      btnView.$el.trigger('mouseleave');
      return ok(!btnView.isUnpublish());
    });
    test('mouseleave published button should change icon and text', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.published
      }).render();
      btnView.$el.trigger('mouseenter');
      btnView.$el.trigger('mouseleave');
      return equal(btnView.$text.html().match(/Published/).length, 1);
    });
    test('click publish should trigger publish event', function() {
      var btnView, triggered;

      btnView = new PublishButtonView({
        model: this.publish
      }).render();
      triggered = false;
      btnView.on("publish", function() {
        return triggered = true;
      });
      btnView.$el.trigger('click');
      return ok(triggered);
    });
    test('publish event callback should transition to published', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.publish
      }).render();
      ok(btnView.isPublish());
      btnView.$el.trigger('mouseenter');
      btnView.$el.trigger('click');
      ok(!btnView.isPublish());
      return ok(btnView.isPublished());
    });
    test('publish event callback should transition back to publish if rejected', function() {
      var btnView;

      this.publishable.prototype.publish = function() {
        this.set("published", false);
        return $.Deferred().reject();
      };
      btnView = new PublishButtonView({
        model: this.publish
      }).render();
      ok(btnView.isPublish());
      btnView.$el.trigger('mouseenter');
      btnView.$el.trigger('click');
      ok(btnView.isPublish());
      return ok(!btnView.isPublished());
    });
    test('click published should trigger unpublish event', function() {
      var btnView, triggered;

      btnView = new PublishButtonView({
        model: this.published
      }).render();
      triggered = false;
      btnView.on("unpublish", function() {
        return triggered = true;
      });
      btnView.$el.trigger('mouseenter');
      btnView.$el.trigger('click');
      return ok(triggered);
    });
    test('published event callback should transition to publish', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.published
      }).render();
      ok(btnView.isPublished());
      btnView.$el.trigger('mouseenter');
      btnView.$el.trigger('click');
      ok(!btnView.isUnpublish());
      return ok(btnView.isPublish());
    });
    test('published event callback should transition back to published if rejected', function() {
      var btnView;

      this.publishable.prototype.unpublish = function() {
        this.set("published", true);
        return $.Deferred().reject();
      };
      btnView = new PublishButtonView({
        model: this.published
      }).render();
      ok(btnView.isPublished());
      btnView.$el.trigger('mouseenter');
      btnView.$el.trigger('click');
      ok(!btnView.isUnpublish());
      return ok(btnView.isPublished());
    });
    return test('click disabled published button should not trigger publish event', function() {
      var btnView;

      btnView = new PublishButtonView({
        model: this.disabled
      }).render();
      ok(btnView.isPublished());
      btnView.$el.trigger('mouseenter');
      btnView.$el.trigger('click');
      return ok(!btnView.isPublish());
    });
  });

}).call(this);

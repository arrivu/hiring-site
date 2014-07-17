(function() {
  define(['jquery', 'compiled/util/kalturaAnalytics', 'vendor/mediaelement-and-player', 'vendor/jquery.cookie'], function($, kalturaAnalytics, mejs) {
    module('kaltura analytics helper', {
      setup: function() {
        this.player = new mejs.PluginMediaElement;
        return this.pluginSettings = {
          partner_id: 'ster',
          kcw_ui_conf: 'cobb',
          domain: 'example.com',
          do_analytics: true,
          parallel_api_calls: 1
        };
      },
      teardown: function() {
        $('.kaltura-analytics').remove();
        return $.cookie('kaltura_analytic_tracker', null, {
          path: '/'
        });
      }
    });
    test('adds event listeners', function() {
      var exp;

      exp = sinon.mock(this.player).expects('addEventListener').atLeast(6);
      kalturaAnalytics("1", this.player, this.pluginSettings);
      return exp.verify();
    });
    test('generate api url', function() {
      var ka;

      ka = kalturaAnalytics("1", this.player, this.pluginSettings);
      if (window.location.protocol === 'http:') {
        return equal(ka.generateApiUrl(), 'http://example.com/api_v3/index.php?', 'generated bad url');
      } else {
        return equal(ka.generateApiUrl(), 'https://example.com/api_v3/index.php?', 'generated bad url');
      }
    });
    test('queue new analytics call', function() {
      var exp, ka;

      ka = kalturaAnalytics("1", this.player, this.pluginSettings);
      exp = sinon.expectation.create([]).once();
      ka.iframes[0].pinger = exp;
      ka.queueAnalyticEvent("oioi");
      if (window.location.protocol === 'http:') {
        equal(ka.iframes[0].queue[0].indexOf('http://example.com/api_v3/index.php?service=stats&action=collect&event%3AentryId=1&event'), 0);
      } else {
        equal(ka.iframes[0].queue[0].indexOf('https://example.com/api_v3/index.php?service=stats&action=collect&event%3AentryId=1&event'), 0);
      }
      ok(ka.iframes[0].queue[0].match(/eventType=oioi/));
      return exp.verify();
    });
    test("don't load if disabled", function() {
      equal(kalturaAnalytics("1", this.player, {
        do_analytics: false
      }), null);
      equal(kalturaAnalytics("1", this.player, {}), null);
      return equal(kalturaAnalytics("1", this.player, null), null);
    });
    test('session cookie is created', function() {
      var ka;

      ka = kalturaAnalytics("1", this.player, this.pluginSettings);
      ok($.cookie('kaltura_analytic_tracker'));
      return equal(ka.kaSession, $.cookie('kaltura_analytic_tracker'));
    });
    return test('iframe created', function() {
      var iframe, ka;

      ka = kalturaAnalytics("1", this.player, this.pluginSettings);
      iframe = $('.kaltura-analytics');
      equal(iframe.length, ka.iframes.length);
      return ok(iframe.hasClass('hidden'));
    });
  });

}).call(this);

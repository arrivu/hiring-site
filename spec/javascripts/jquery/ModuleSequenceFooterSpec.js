(function() {
  define(['jquery', 'compiled/jquery/ModuleSequenceFooter'], function($) {
    var itemTooltipData, moduleTooltipData, nullButtonData;

    module('ModuleSequenceFooter: init', {
      setup: function() {
        this.$testEl = $('<div>');
        $('#fixtures').append(this.$testEl);
        return sinon.stub($.fn.moduleSequenceFooter.MSFClass.prototype, 'fetch', function() {
          return {
            done: function() {}
          };
        });
      },
      teardown: function() {
        this.$testEl.remove();
        return $.fn.moduleSequenceFooter.MSFClass.prototype.fetch.restore();
      }
    });
    test('returns jquery object of itself', function() {
      var jobj;

      jobj = this.$testEl.moduleSequenceFooter({
        assetType: 'Assignment',
        assetID: 42
      });
      return ok(jobj instanceof $, 'returns an jquery instance of itself');
    });
    test('throws error if option is not set', function() {
      return throws((function() {
        return this.$testEl.moduleSequenceFooter();
      }), 'throws error when no options are passed in');
    });
    test('generatess a url based on the course_id', function() {
      var msf;

      msf = new $.fn.moduleSequenceFooter.MSFClass({
        courseID: 42,
        assetType: 'Assignment',
        assetID: 42
      });
      return equal(msf.url, "/api/v1/courses/42/module_item_sequence", "generates a url based on the courseID");
    });
    test('attaches msfAnimation function', function() {
      this.$testEl.moduleSequenceFooter({
        assetType: 'Assignment',
        assetID: 42
      });
      return notStrictEqual(this.$testEl.msfAnimation, void 0, 'msfAnimation function defined');
    });
    test('accepts animation option', function() {
      $.fn.moduleSequenceFooter.MSFClass.prototype.fetch.restore();
      sinon.stub($.fn.moduleSequenceFooter.MSFClass.prototype, 'fetch', function() {
        var d;

        this.success({
          items: [
            {
              prev: null,
              current: {
                id: 42,
                module_id: 73,
                title: 'A lonely page',
                type: 'Page'
              },
              next: {
                id: 43,
                module_id: 73,
                title: 'Another lonely page',
                type: 'Page'
              }
            }
          ],
          modules: [
            {
              id: 73,
              name: 'A lonely module'
            }
          ]
        });
        d = $.Deferred();
        d.resolve();
        return d;
      });
      this.$testEl.moduleSequenceFooter({
        assetType: 'Assignment',
        assetID: 42,
        animation: false
      });
      equal(this.$testEl.find('.module-sequence-footer.no-animation').length, 1, 'no-animation applied to module-sequence-footer');
      equal(this.$testEl.find('.module-sequence-padding.no-animation').length, 1, 'no-animation applied to module-sequence-padding');
      this.$testEl.msfAnimation(true);
      equal(this.$testEl.find('.module-sequence-footer:not(.no-animation)').length, 1, 'no-animation removed from module-sequence-footer');
      return equal(this.$testEl.find('.module-sequence-padding:not(.no-animation)').length, 1, 'no-animation removed from module-sequence-padding');
    });
    module('ModuleSequenceFooter: rendering', {
      setup: function() {
        this.server = sinon.fakeServer.create();
        this.$testEl = $('<div>');
        return $('#fixtures').append(this.$testEl);
      },
      teardown: function() {
        this.server.restore();
        return this.$testEl.remove();
      }
    });
    nullButtonData = {
      items: [
        {
          prev: null,
          current: {
            id: 768,
            module_id: 123,
            title: "A lonely page",
            type: "Page"
          },
          next: null
        }
      ],
      modules: [
        {
          id: 123,
          name: "Module A"
        }
      ]
    };
    test('there is no button when next or prev data is null', function() {
      this.server.respondWith("GET", "/api/v1/courses/42/module_item_sequence?asset_type=Assignment&asset_id=123", [
        200, {
          "Content-Type": "application/json"
        }, JSON.stringify(nullButtonData)
      ]);
      this.$testEl.moduleSequenceFooter({
        courseID: 42,
        assetType: 'Assignment',
        assetID: 123
      });
      this.server.respond();
      return ok(this.$testEl.find('a').length === 0, 'no buttons rendered');
    });
    moduleTooltipData = {
      items: [
        {
          prev: {
            id: 769,
            module_id: 111,
            title: "Project 1",
            type: "Assignment"
          },
          current: {
            id: 768,
            module_id: 123,
            title: "A lonely page",
            type: "Page"
          },
          next: {
            id: 111,
            module_id: 666,
            title: "Project 33",
            type: "Assignment"
          }
        }
      ],
      modules: [
        {
          id: 123,
          name: "Module A"
        }, {
          id: 666,
          name: "Module B"
        }, {
          id: 111,
          name: "Module C"
        }
      ]
    };
    test('buttons show modules tooltip when current module id != next or prev module id', function() {
      this.server.respondWith("GET", "/api/v1/courses/42/module_item_sequence?asset_type=Assignment&asset_id=123", [
        200, {
          "Content-Type": "application/json"
        }, JSON.stringify(moduleTooltipData)
      ]);
      this.$testEl.moduleSequenceFooter({
        courseID: 42,
        assetType: 'Assignment',
        assetID: 123
      });
      this.server.respond();
      ok(this.$testEl.find('a').first().data('tooltip-title').match('Module C'), "displays previous module tooltip");
      return ok(this.$testEl.find('a').last().data('tooltip-title').match('Module B'), "displays next module tooltip");
    });
    itemTooltipData = {
      items: [
        {
          prev: {
            id: 769,
            module_id: 123,
            title: "Project 1",
            type: "Assignment"
          },
          current: {
            id: 768,
            module_id: 123,
            title: "A lonely page",
            type: "Page"
          },
          next: {
            id: 111,
            module_id: 123,
            title: "Project 33",
            type: "Assignment"
          }
        }
      ],
      modules: [
        {
          id: 123,
          name: "Module A"
        }
      ]
    };
    test('buttons show item tooltip when current module id == next or prev module id', function() {
      this.server.respondWith("GET", "/api/v1/courses/42/module_item_sequence?asset_type=Assignment&asset_id=123", [
        200, {
          "Content-Type": "application/json"
        }, JSON.stringify(itemTooltipData)
      ]);
      this.$testEl.moduleSequenceFooter({
        courseID: 42,
        assetType: 'Assignment',
        assetID: 123
      });
      this.server.respond();
      ok(this.$testEl.find('a').first().data('tooltip-title').match('Project 1'), "displays previous item tooltip");
      return ok(this.$testEl.find('a').last().data('tooltip-title').match('Project 33'), "displays next item tooltip");
    });
    test('if url has a module_item_id use that as the assetID and ModuleItem as the type instead', function() {
      this.server.respondWith("GET", "/api/v1/courses/42/module_item_sequence?asset_type=ModuleItem&asset_id=999", [
        200, {
          "Content-Type": "application/json"
        }, JSON.stringify({})
      ]);
      this.$testEl.moduleSequenceFooter({
        courseID: 42,
        assetType: 'Assignment',
        assetID: 123,
        location: {
          search: "?module_item_id=999"
        }
      });
      this.server.respond();
      return equal(this.server.requests[0].status, '200', 'Request was successful');
    });
    return test('show gets called when rendering', function() {
      this.sandbox.stub(this.$testEl, 'show');
      this.server.respondWith("GET", "/api/v1/courses/42/module_item_sequence?asset_type=Assignment&asset_id=123", [
        200, {
          "Content-Type": "application/json"
        }, JSON.stringify(itemTooltipData)
      ]);
      this.$testEl.moduleSequenceFooter({
        courseID: 42,
        assetType: 'Assignment',
        assetID: 123
      });
      this.server.respond();
      return ok(this.$testEl.show.called, 'show called');
    });
  });

}).call(this);

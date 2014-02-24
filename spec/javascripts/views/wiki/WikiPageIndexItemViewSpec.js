(function() {
  define(['compiled/models/WikiPage', 'compiled/views/wiki/WikiPageIndexItemView'], function(WikiPage, WikiPageIndexItemView) {
    var testRights;

    module('WikiPageIndexItemView');
    test('model.view maintained by item view', function() {
      var model, view;

      model = new WikiPage;
      view = new WikiPageIndexItemView({
        model: model
      });
      strictEqual(model.view, view, 'model.view is set to the item view');
      view.render();
      return strictEqual(model.view, view, 'model.view is set to the item view');
    });
    test('detach/reattach the publish icon view', function() {
      var $previousEl, model, view;

      model = new WikiPage;
      view = new WikiPageIndexItemView({
        model: model
      });
      view.render();
      $previousEl = view.$el.find('> *:first-child');
      view.publishIconView.$el.data('test-data', 'test-is-good');
      view.render();
      equal($previousEl.parent().length, 0, 'previous content removed');
      return equal(view.publishIconView.$el.data('test-data'), 'test-is-good', 'test data preserved (by detach)');
    });
    test('delegate useAsFrontPage to the model', function() {
      var model, stub, view;

      model = new WikiPage({
        front_page: false,
        published: true
      });
      view = new WikiPageIndexItemView({
        model: model
      });
      stub = sinon.stub(model, 'setFrontPage');
      view.useAsFrontPage();
      return ok(stub.calledOnce);
    });
    module('WikiPageIndexItemView:JSON');
    testRights = function(subject, options) {
      return test("" + subject, function() {
        var json, key, model, view, _results;

        model = new WikiPage;
        view = new WikiPageIndexItemView({
          model: model,
          contextName: options.contextName,
          WIKI_RIGHTS: options.WIKI_RIGHTS
        });
        json = view.toJSON();
        _results = [];
        for (key in options.CAN) {
          _results.push(strictEqual(json.CAN[key], options.CAN[key], "CAN." + key));
        }
        return _results;
      });
    };
    testRights('CAN (manage course)', {
      contextName: 'courses',
      WIKI_RIGHTS: {
        read: true,
        manage: true
      },
      CAN: {
        MANAGE: true,
        PUBLISH: true
      }
    });
    testRights('CAN (manage group)', {
      contextName: 'groups',
      WIKI_RIGHTS: {
        read: true,
        manage: true
      },
      CAN: {
        MANAGE: true,
        PUBLISH: false
      }
    });
    testRights('CAN (read)', {
      contextName: 'courses',
      WIKI_RIGHTS: {
        read: true
      },
      CAN: {
        MANAGE: false,
        PUBLISH: false
      }
    });
    return testRights('CAN (null)', {
      CAN: {
        MANAGE: false,
        PUBLISH: false
      }
    });
  });

}).call(this);

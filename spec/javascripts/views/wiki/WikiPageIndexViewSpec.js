(function() {
  define(['compiled/collections/WikiPageCollection', 'compiled/views/wiki/WikiPageIndexView', 'jquery', 'jquery.disableWhileLoading'], function(WikiPageCollection, WikiPageIndexView, $) {
    var testRights;

    module('WikiPageIndexView:sort', {
      setup: function() {
        this.collection = new WikiPageCollection;
        this.view = new WikiPageIndexView({
          collection: this.collection
        });
        this.$a = $('<a/>');
        this.$a.data('sort-field', 'created_at');
        this.ev = $.Event('click');
        return this.ev.currentTarget = this.$a.get(0);
      }
    });
    test('sort delegates to the collection sortByField', function() {
      var sortByFieldStub;

      sortByFieldStub = sinon.stub(this.collection, 'sortByField');
      this.view.sort(this.ev);
      return ok(sortByFieldStub.calledOnce, 'collection sortByField called once');
    });
    test('view disabled while sorting', function() {
      var dfd, disableWhileLoadingStub, fetchStub;

      dfd = $.Deferred();
      fetchStub = sinon.stub(this.collection, 'fetch').returns(dfd);
      disableWhileLoadingStub = sinon.stub(this.view.$el, 'disableWhileLoading');
      this.view.sort(this.ev);
      ok(disableWhileLoadingStub.calledOnce, 'disableWhileLoading called once');
      return ok(disableWhileLoadingStub.calledWith(dfd), 'disableWhileLoading called with correct deferred object');
    });
    test('view disabled while sorting again', function() {
      var dfd, disableWhileLoadingStub, fetchStub;

      dfd = $.Deferred();
      fetchStub = sinon.stub(this.collection, 'fetch').returns(dfd);
      disableWhileLoadingStub = sinon.stub(this.view.$el, 'disableWhileLoading');
      this.view.sort(this.ev);
      ok(disableWhileLoadingStub.calledOnce, 'disableWhileLoading called once');
      return ok(disableWhileLoadingStub.calledWith(dfd), 'disableWhileLoading called with correct deferred object');
    });
    test('renderSortHeaders called when sorting changes', function() {
      var renderSortHeadersStub;

      renderSortHeadersStub = sinon.stub(this.view, 'renderSortHeaders');
      this.collection.trigger('sortChanged', 'created_at');
      ok(renderSortHeadersStub.calledOnce, 'renderSortHeaders called once');
      return equal(this.view.currentSortField, 'created_at', 'currentSortField set correctly');
    });
    module('WikiPageIndexView:JSON');
    testRights = function(subject, options) {
      return test("" + subject, function() {
        var collection, json, key, view, _results;

        collection = new WikiPageCollection;
        view = new WikiPageIndexView({
          collection: collection,
          contextAssetString: options.contextAssetString,
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
      contextAssetString: 'course_73',
      WIKI_RIGHTS: {
        read: true,
        create_page: true,
        manage: true
      },
      CAN: {
        CREATE: true,
        MANAGE: true,
        PUBLISH: true
      }
    });
    testRights('CAN (manage group)', {
      contextAssetString: 'group_73',
      WIKI_RIGHTS: {
        read: true,
        create_page: true,
        manage: true
      },
      CAN: {
        CREATE: true,
        MANAGE: true,
        PUBLISH: false
      }
    });
    testRights('CAN (read)', {
      contextAssetString: 'course_73',
      WIKI_RIGHTS: {
        read: true
      },
      CAN: {
        CREATE: false,
        MANAGE: false,
        PUBLISH: false
      }
    });
    return testRights('CAN (null)', {
      CAN: {
        CREATE: false,
        MANAGE: false,
        PUBLISH: false
      }
    });
  });

}).call(this);

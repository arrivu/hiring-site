(function() {
  define(['compiled/models/WikiPage', 'compiled/collections/WikiPageCollection'], function(WikiPage, WikiPageCollection) {
    var checkFrontPage;

    module('WikiPageCollection');
    checkFrontPage = function(collection) {
      var total;

      total = collection.reduce((function(i, model) {
        return i += model.get('front_page') ? 1 : 0;
      }), 0);
      return total <= 1;
    };
    test('only a single front_page per collection', function() {
      var collection, i, _i;

      collection = new WikiPageCollection;
      for (i = _i = 0; _i <= 2; i = ++_i) {
        collection.add(new WikiPage);
      }
      ok(checkFrontPage(collection), 'initial state');
      collection.models[0].set('front_page', true);
      ok(checkFrontPage(collection), 'set front_page once');
      collection.models[1].set('front_page', true);
      ok(checkFrontPage(collection), 'set front_page twice');
      collection.models[2].set('front_page', true);
      return ok(checkFrontPage(collection), 'set front_page thrice');
    });
    module('WikiPageCollection:sorting', {
      setup: function() {
        return this.collection = new WikiPageCollection;
      }
    });
    test('default sort is title', function() {
      return equal(this.collection.currentSortField, 'title', 'default sort set correctly');
    });
    test('default sort orders', function() {
      equal(this.collection.sortOrders['title'], 'asc', 'default title sort order');
      equal(this.collection.sortOrders['created_at'], 'desc', 'default created_at sort order');
      return equal(this.collection.sortOrders['updated_at'], 'desc', 'default updated_at sort order');
    });
    test('sort order toggles (sort on same field)', function() {
      this.collection.currentSortField = 'created_at';
      this.collection.sortOrders['created_at'] = 'desc';
      this.collection.setSortField('created_at');
      return equal(this.collection.sortOrders['created_at'], 'asc', 'sort order toggled');
    });
    test('sort order does not toggle (sort on different field)', function() {
      this.collection.currentSortField = 'title';
      this.collection.sortOrders['created_at'] = 'desc';
      this.collection.setSortField('created_at');
      return equal(this.collection.sortOrders['created_at'], 'desc', 'sort order remains');
    });
    test('sort order can be forced', function() {
      this.collection.currentSortField = 'title';
      this.collection.setSortField('created_at', 'asc');
      equal(this.collection.currentSortField, 'created_at', 'sort field set');
      equal(this.collection.sortOrders['created_at'], 'asc', 'sort order forced');
      this.collection.setSortField('created_at', 'asc');
      equal(this.collection.currentSortField, 'created_at', 'sort field remains');
      return equal(this.collection.sortOrders['created_at'], 'asc', 'sort order remains');
    });
    test('setting sort triggers a sortChanged event', function() {
      var sortChangedSpy;

      sortChangedSpy = sinon.spy();
      this.collection.on('sortChanged', sortChangedSpy);
      this.collection.setSortField('created_at');
      ok(sortChangedSpy.calledOnce, 'sortChanged event triggered once');
      return ok(sortChangedSpy.calledWith(this.collection.currentSortField, this.collection.sortOrders), 'sortChanged triggered with parameters');
    });
    test('setting sort sets fetch parameters', function() {
      this.collection.setSortField('created_at', 'desc');
      ok(this.collection.options, 'options exists');
      ok(this.collection.options.params, 'params exists');
      equal(this.collection.options.params.sort, 'created_at', 'sort param set');
      return equal(this.collection.options.params.order, 'desc', 'order param set');
    });
    test('sortByField delegates to setSortField', function() {
      var fetchStub, setSortFieldStub;

      setSortFieldStub = sinon.stub(this.collection, 'setSortField');
      fetchStub = sinon.stub(this.collection, 'fetch');
      this.collection.sortByField('created_at', 'desc');
      ok(setSortFieldStub.calledOnce, 'setSortField called once');
      return ok(setSortFieldStub.calledWith('created_at', 'desc'), 'setSortField called with correct arguments');
    });
    return test('sortByField triggers a fetch', function() {
      var fetchStub;

      fetchStub = sinon.stub(this.collection, 'fetch');
      this.collection.sortByField('created_at', 'desc');
      return ok(fetchStub.calledOnce, 'fetch called once');
    });
  });

}).call(this);

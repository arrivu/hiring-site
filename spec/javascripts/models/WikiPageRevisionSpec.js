(function() {
  define(['underscore', 'compiled/models/WikiPageRevision'], function(_, WikiPageRevision) {
    module('WikiPageRevision::urls');
    test('captures contextAssetString, pageUrl, latest, and summary as constructor options', function() {
      var revision;

      revision = new WikiPageRevision({}, {
        contextAssetString: 'course_73',
        pageUrl: 'page-url',
        latest: true,
        summary: true
      });
      strictEqual(revision.contextAssetString, 'course_73', 'contextAssetString');
      strictEqual(revision.pageUrl, 'page-url', 'pageUrl');
      strictEqual(revision.latest, true, 'latest');
      return strictEqual(revision.summary, true, 'summary');
    });
    test('urlRoot uses the context path and pageUrl', function() {
      var revision;

      revision = new WikiPageRevision({}, {
        contextAssetString: 'course_73',
        pageUrl: 'page-url'
      });
      return strictEqual(revision.urlRoot(), '/api/v1/courses/73/pages/page-url/revisions', 'base url');
    });
    test('url returns urlRoot if latest and id are not specified', function() {
      var revision;

      revision = new WikiPageRevision({}, {
        contextAssetString: 'course_73',
        pageUrl: 'page-url'
      });
      return strictEqual(revision.url(), '/api/v1/courses/73/pages/page-url/revisions', 'base url');
    });
    test('url is affected by the latest flag', function() {
      var revision;

      revision = new WikiPageRevision({
        id: 42
      }, {
        contextAssetString: 'course_73',
        pageUrl: 'page-url',
        latest: true
      });
      return strictEqual(revision.url(), '/api/v1/courses/73/pages/page-url/revisions/latest', 'latest');
    });
    test('url is affected by the id', function() {
      var revision;

      revision = new WikiPageRevision({
        id: 42
      }, {
        contextAssetString: 'course_73',
        pageUrl: 'page-url'
      });
      return strictEqual(revision.url(), '/api/v1/courses/73/pages/page-url/revisions/42', 'id');
    });
    module('WikiPageRevision::parse');
    test('parse sets the id to the url', function() {
      var revision;

      revision = new WikiPageRevision({
        url: 'url'
      });
      strictEqual(revision.get('id'), 'url', 'url set through constructor');
      return strictEqual(revision.parse({
        url: 'bob'
      }).id, 'bob', 'url set through parse');
    });
    test('toJSON omits the id', function() {
      var revision;

      revision = new WikiPageRevision({
        url: 'url'
      });
      return strictEqual(revision.toJSON().id, void 0, 'id omitted');
    });
    module('WikiPageRevision::fetch');
    test('the summary flag is passed to the server', function() {
      var revision, _ref, _ref1, _ref2;

      this.stub($, 'ajax').returns($.Deferred());
      revision = new WikiPageRevision({}, {
        contextAssetString: 'course_73',
        pageUrl: 'page-url',
        summary: true
      });
      revision.fetch();
      return strictEqual((_ref = $.ajax.args[0]) != null ? (_ref1 = _ref[0]) != null ? (_ref2 = _ref1.data) != null ? _ref2.summary : void 0 : void 0 : void 0, true, 'summary provided');
    });
    return test('pollForChanges performs a fetch at most every interval', function() {
      var revision;

      revision = new WikiPageRevision({}, {
        pageUrl: 'page-url'
      });
      this.sandbox.useFakeTimers();
      this.stub(revision, 'fetch').returns($.Deferred());
      revision.pollForChanges(5000);
      revision.pollForChanges(5000);
      this.sandbox.clock.tick(4000);
      ok(!revision.fetch.called, 'not called until interval elapses');
      this.sandbox.clock.tick(2000);
      return ok(revision.fetch.calledOnce, 'called once interval elapses');
    });
  });

}).call(this);

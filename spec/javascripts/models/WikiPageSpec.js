(function() {
  define(['compiled/models/WikiPage', 'underscore'], function(WikiPage, _) {
    var wikiPageObj;

    wikiPageObj = function(options) {
      var defaults;

      if (options == null) {
        options = {};
      }
      defaults = {
        body: "<p>content for the uploading of content</p>",
        created_at: "2013-05-10T13:18:27-06:00",
        editing_roles: "teachers",
        front_page: false,
        hide_from_students: false,
        locked_for_user: false,
        published: false,
        title: "Front Page-3",
        updated_at: "2013-06-13T10:30:37-06:00",
        url: "front-page-2"
      };
      return _.extend(defaults, options);
    };
    module('WikiPage');
    test('latestRevision is only available when a url is provided', function() {
      var wikiPage;

      wikiPage = new WikiPage;
      equal(wikiPage.latestRevision(), null, 'not provided without url');
      wikiPage = new WikiPage({
        url: 'url'
      });
      return notEqual(wikiPage.latestRevision(), null, 'provided with url');
    });
    test('revision passed to latestRevision', function() {
      var wikiPage;

      wikiPage = new WikiPage({
        url: 'url'
      }, {
        revision: 42
      });
      return equal(wikiPage.latestRevision().get('revision_id'), 42, 'revision passed to latestRevision');
    });
    test('latestRevision should be marked as latest', function() {
      var wikiPage;

      wikiPage = new WikiPage({
        url: 'url'
      });
      return equal(wikiPage.latestRevision().latest, true, 'marked as latest');
    });
    test('latestRevision should default to summary', function() {
      var wikiPage;

      wikiPage = new WikiPage({
        url: 'url'
      });
      return equal(wikiPage.latestRevision().summary, true, 'defaulted to summary');
    });
    module('WikiPage:Publishable');
    test('publishable', function() {
      var wikiPage;

      wikiPage = new WikiPage({
        front_page: false,
        published: true
      });
      strictEqual(wikiPage.get('publishable'), true, 'publishable set during construction');
      wikiPage.set('front_page', true);
      return strictEqual(wikiPage.get('publishable'), false, 'publishable set when front_page changed');
    });
    test('deletable', function() {
      var wikiPage;

      wikiPage = new WikiPage({
        front_page: false,
        published: true
      });
      strictEqual(wikiPage.get('deletable'), true, 'deletable set during construction');
      wikiPage.set('front_page', true);
      return strictEqual(wikiPage.get('deletable'), false, 'deletable set when front_page changed');
    });
    module('WikiPage:Sync');
    test('sets the id during construction', function() {
      var wikiPage;

      wikiPage = new WikiPage(wikiPageObj());
      equal(wikiPage.get('url'), 'front-page-2');
      return equal(wikiPage.get('id'), wikiPage.get('url'), 'Sets id to url');
    });
    test('sets the id during parse', function() {
      var parseResponse, wikiPage;

      wikiPage = new WikiPage;
      parseResponse = wikiPage.parse(wikiPageObj());
      equal(parseResponse.url, 'front-page-2');
      return equal(parseResponse.id, parseResponse.url, 'Sets id to url');
    });
    test('removes the id during toJSON', function() {
      var json, wikiPage;

      wikiPage = new WikiPage(wikiPageObj());
      json = wikiPage.toJSON();
      return equal(json.id, void 0, 'Removes id from serialized json');
    });
    test('parse removes wiki_page namespace added by api', function() {
      var namespacedObj, parseResponse, wikiPage;

      wikiPage = new WikiPage;
      namespacedObj = {};
      namespacedObj.wiki_page = wikiPageObj();
      parseResponse = wikiPage.parse(namespacedObj);
      return ok(!_.isObject(parseResponse.wiki_page), "Removes the wiki_page namespace");
    });
    test('present includes the context information', function() {
      var json, wikiPage;

      wikiPage = new WikiPage({}, {
        contextAssetString: 'course_31'
      });
      json = wikiPage.present();
      equal(json.contextName, 'courses', 'contextName');
      return equal(json.contextId, 31, 'contextId');
    });
    test('publish convenience method', 3, function() {
      var wikiPage;

      wikiPage = new WikiPage(wikiPageObj());
      sinon.stub(wikiPage, 'save', function(attributes, options) {
        ok(attributes, 'attributes present');
        ok(attributes.wiki_page, 'wiki_page present');
        return strictEqual(attributes.wiki_page.published, true, 'published provided correctly');
      });
      return wikiPage.publish();
    });
    test('unpublish convenience method', 3, function() {
      var wikiPage;

      wikiPage = new WikiPage(wikiPageObj());
      sinon.stub(wikiPage, 'save', function(attributes, options) {
        ok(attributes, 'attributes present');
        ok(attributes.wiki_page, 'wiki_page present');
        return strictEqual(attributes.wiki_page.published, false, 'published provided correctly');
      });
      return wikiPage.unpublish();
    });
    test('setFrontPage convenience method', 3, function() {
      var wikiPage;

      wikiPage = new WikiPage(wikiPageObj());
      sinon.stub(wikiPage, 'save', function(attributes, options) {
        ok(attributes, 'attributes present');
        ok(attributes.wiki_page, 'wiki_page present');
        return strictEqual(attributes.wiki_page.front_page, true, 'front_page provided correctly');
      });
      return wikiPage.setFrontPage();
    });
    return test('unsetFrontPage convenience method', 3, function() {
      var wikiPage;

      wikiPage = new WikiPage(wikiPageObj());
      sinon.stub(wikiPage, 'save', function(attributes, options) {
        ok(attributes, 'attributes present');
        ok(attributes.wiki_page, 'wiki_page present');
        return strictEqual(attributes.wiki_page.front_page, false, 'front_page provided correctly');
      });
      return wikiPage.unsetFrontPage();
    });
  });

}).call(this);

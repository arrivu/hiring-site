(function() {
  var __hasProp = {}.hasOwnProperty;

  define(['compiled/models/TurnitinSettings'], function(TurnitinSettings) {
    module("TurnitinSettings");
    module("TurnitinSettings#constructor");
    test("assigns sPaperCheck", function() {
      var ts;

      ts = new TurnitinSettings({
        s_paper_check: true
      });
      return deepEqual(ts.sPaperCheck, true);
    });
    test("assigns originalityReportVisibility", function() {
      var ts;

      ts = new TurnitinSettings({
        originality_report_visibility: 'after_grading'
      });
      return deepEqual(ts.originalityReportVisibility, 'after_grading');
    });
    test("assigns internetCheck", function() {
      var ts;

      ts = new TurnitinSettings({
        internet_check: true
      });
      return deepEqual(ts.internetCheck, true);
    });
    test("assigns excludeBiblio", function() {
      var ts;

      ts = new TurnitinSettings({
        exclude_biblio: false
      });
      return deepEqual(ts.excludeBiblio, false);
    });
    test("assigns excludeQuoted", function() {
      var ts;

      ts = new TurnitinSettings({
        exclude_quoted: false
      });
      return strictEqual(ts.excludeQuoted, false);
    });
    test("assigns journalCheck", function() {
      var ts;

      ts = new TurnitinSettings({
        journal_check: true
      });
      return strictEqual(ts.journalCheck, true);
    });
    test("assigns excludeSmallMatchesType", function() {
      var ts;

      ts = new TurnitinSettings({
        exclude_small_matches_type: 'words'
      });
      return strictEqual(ts.excludeSmallMatchesType, 'words');
    });
    test("assigns excludeSmallMatchesValue", function() {
      var ts;

      ts = new TurnitinSettings({
        exclude_small_matches_value: 100
      });
      return strictEqual(ts.excludeSmallMatchesValue, 100);
    });
    test("assigns correct percent", function() {
      var ts;

      ts = new TurnitinSettings({
        exclude_small_matches_type: 'words',
        exclude_small_matches_value: 100
      });
      strictEqual(ts.percent(), "");
      ts = new TurnitinSettings({
        exclude_small_matches_type: 'percent',
        exclude_small_matches_value: 100
      });
      return strictEqual(ts.percent(), 100);
    });
    test("assigns correct words", function() {
      var ts;

      ts = new TurnitinSettings({
        exclude_small_matches_type: 'words',
        exclude_small_matches_value: 100
      });
      strictEqual(ts.words(), 100);
      ts = new TurnitinSettings({
        exclude_small_matches_type: 'percent',
        exclude_small_matches_value: 100
      });
      return strictEqual(ts.words(), "");
    });
    module("TurnitinSettings#toJSON");
    test("it converts back to snake_case", function() {
      var options, ts;

      options = {
        exclude_small_matches_value: 100,
        exclude_small_matches_type: 'words',
        journal_check: false,
        exclude_quoted: false,
        exclude_biblio: true,
        internet_check: true,
        originality_report_visibility: 'after_grading',
        s_paper_check: true
      };
      ts = new TurnitinSettings(options);
      return deepEqual(ts.toJSON(), options);
    });
    module("TurnitinSettings#excludesSmallMatches");
    test("returns true when excludeSmallMatchesType is not null", function() {
      var ts;

      ts = new TurnitinSettings({
        exclude_small_matches_type: 'words'
      });
      return strictEqual(ts.excludesSmallMatches(), true);
    });
    test("returns false when excludeSmallMatchesType is null", function() {
      var ts;

      ts = new TurnitinSettings({
        exclude_small_matches_type: null
      });
      return strictEqual(ts.excludesSmallMatches(), false);
    });
    module("TurnitinSettings#present", {
      setup: function() {
        this.options = {
          exclude_small_matches_value: 100,
          exclude_small_matches_type: 'words',
          journal_check: false,
          exclude_quoted: false,
          exclude_biblio: true,
          internet_check: true,
          originality_report_visibility: 'after_grading',
          s_paper_check: true
        };
        this.ts = new TurnitinSettings(this.options);
        return this.view = this.ts.present();
      }
    });
    test("includes excludesSmallMatches", function() {
      return strictEqual(this.view.excludesSmallMatches, this.ts.excludesSmallMatches());
    });
    return test("includes all the default fields", function() {
      var key, value, _ref, _results;

      _ref = this.view;
      _results = [];
      for (key in _ref) {
        if (!__hasProp.call(_ref, key)) continue;
        value = _ref[key];
        if (key !== 'excludesSmallMatches' && key !== 'words' && key !== 'percent') {
          _results.push(strictEqual(value, this.ts[key]));
        }
      }
      return _results;
    });
  });

}).call(this);

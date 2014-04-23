(function() {
  define(['compiled/handlebars_helpers', 'underscore'], function(_arg, _) {
    var context, helpers, testCheckbox;

    helpers = _arg.helpers;
    module('handlebars_helpers');
    module('checkbox');
    context = {
      likes: {
        tacos: true
      },
      human: true,
      alien: false
    };
    testCheckbox = function(context, prop, hash) {
      var $input, checks, key, val, _results;

      if (hash == null) {
        hash = {};
      }
      $input = $("<span>" + (helpers.checkbox.call(context, prop, {
        hash: hash
      }).string) + "</span>").find('input').eq(1);
      checks = _.defaults(hash, {
        value: 1,
        tagName: 'INPUT',
        type: 'checkbox',
        name: prop,
        checked: context[prop],
        id: prop
      });
      _results = [];
      for (key in checks) {
        val = checks[key];
        _results.push(equal($input.prop(key), val));
      }
      return _results;
    };
    test('simple case', function() {
      return testCheckbox(context, 'human');
    });
    test('custom hash attributes', function() {
      var hash;

      hash = {
        "class": 'foo bar baz',
        id: 'custom_id'
      };
      return testCheckbox(context, 'human', hash, hash);
    });
    test('nested property', function() {
      return testCheckbox(context, 'likes.tacos', {
        id: 'likes_tacos',
        name: 'likes[tacos]',
        checked: context.likes.tacos
      });
    });
    test('titleize', function() {
      equal(helpers.titleize('test_string'), 'Test String');
      equal(helpers.titleize(null), '');
      return equal(helpers.titleize('test_ _string'), 'Test String');
    });
    test('toPrecision', function() {
      return equal(helpers.toPrecision(3.6666666, 2), '3.7');
    });
    module('truncate');
    test('default truncates 30 characters', function() {
      var text, truncText;

      text = "asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf";
      truncText = helpers.truncate(text);
      return equal(truncText.length, 30, "Truncates down to 30 letters");
    });
    test('expects options for max (length)', function() {
      var text, truncText;

      text = "asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf";
      truncText = helpers.truncate(text, 10);
      return equal(truncText.length, 10, "Truncates down to 10 letters");
    });
    return test('supports truncation left', function() {
      var text, truncText;

      text = "going to the store";
      truncText = helpers.truncate_left(text, 15);
      return equal(truncText, "...to the store", "Reverse truncates");
    });
  });

}).call(this);

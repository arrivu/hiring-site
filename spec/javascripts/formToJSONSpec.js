(function() {
  define(['jquery', 'jquery.toJSON'], function($) {
    var $datepickerEl;

    $datepickerEl = function() {
      return $("<input type='text' name='date' class='datetime_field_enabled'/>");
    };
    module('jquery.toJSON', {
      setup: function() {
        this.form = $('<form/>');
        return this.form.html("<input type=\"text\" name=\"foo\"               value=\"foo\">\n<input type=\"text\" name=\"arr[]\"             value=\"1\">\n<input type=\"text\" name=\"arr[]\"             value=\"2\">\n<input type=\"text\" name=\"nested[foo]\"       value=\"nested[foo]\">\n<input type=\"text\" name=\"nested[bar]\"       value=\"nested[bar]\">\n<input type=\"text\" name=\"nested[baz][qux]\"  value=\"nested[baz][qux]\">\n<input type=\"text\" name=\"nested[arr][]\"     value=\"1\">\n<input type=\"text\" name=\"nested[arr][]\"     value=\"2\">");
      }
    });
    test("serializes to a JSON string correctly", function() {
      var expected;

      expected = {
        foo: 'foo',
        arr: ['1', '2'],
        nested: {
          foo: 'nested[foo]',
          bar: 'nested[bar]',
          baz: {
            qux: 'nested[baz][qux]'
          },
          arr: ['1', '2']
        }
      };
      return equal(JSON.stringify(expected), JSON.stringify(this.form));
    });
    test("returns null if element with datetime_field enabled class has undefined\nfor $.data( 'date' )", function() {
      this.form.prepend($datepickerEl());
      return strictEqual(this.form.toJSON().date, null);
    });
    return test("returns date object for form element with datetime_field_enabled", function() {
      var $dateEl, date;

      $dateEl = $datepickerEl();
      this.form.prepend($dateEl);
      date = Date.now();
      $dateEl.data('date', date);
      $dateEl.val(date);
      return strictEqual(this.form.toJSON().date, date);
    });
  });

}).call(this);

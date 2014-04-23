(function() {
  define(['jquery'], function($) {
    $.fn.toString = function() {
      var className, id, str, tag;

      if (!this.length) {
        return '';
      }
      id = this.attr('id');
      className = this.attr('class').replace(/\s/g, '.');
      tag = this[0].tagName.toLowerCase();
      str = tag;
      if (id) {
        str += "#" + id;
      }
      if (className) {
        str += "." + className;
      }
      return "<" + str + ">";
    };
    return {
      isVisible: function($el, message) {
        if (message == null) {
          message = '';
        }
        ok($el.length, "elements found");
        return ok($el.is(':visible'), ("" + $el + " is visible ") + message);
      },
      isHidden: function($el, message) {
        ok($el.length, "elements found");
        return ok(!$el.is(':visible'), ("" + $el + " is hidden ") + message);
      },
      hasClass: function($el, className, message) {
        ok($el.length, "elements found");
        return ok($el.hasClass(className), ("" + $el + " has class " + className + " ") + message);
      }
    };
  });

}).call(this);

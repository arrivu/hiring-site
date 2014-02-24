(function() {
  define(['jquery', 'compiled/widget/CustomList', 'helpers/simulateClick'], function($, CustomList, simulateClick) {
    module('CustomList', {
      setup: function() {
        var index, items, _i;

        this.el = $("<div>\n <style>\n #customList,\n .customListWrapper { border: solid 1px; width: 300px; }\n\n .customListWrapper { position: absolute; left: 350px; top: 80px;}\n\n #customList ul,\n .customListWrapper ul,\n .customListGhost { padding: 0; margin: 0; list-style: none; width: 300px;}\n\n #customList li,\n .customListWrapper li,\n .customListGhost li { padding: 0px; border-top: solid 1px; width: 100%;}\n\n #customList li a,\n .customListWrapper li a,\n .customListGhost li a{ display: block; padding: 10px; background: #fff;}\n\n .customListGhost li { border: solid 1px;}\n\n .customListWrapper ul { height: 400px; overflow: auto; }\n\n .customListWrapper li.on a { background: #ccc; }\n </style>\n\n\n <div id=\"customList\">\n\n   <button class=\"customListOpen\">Edit this list</button>\n\n   <ul id=\"list\" class=\"menu-item-drop-column-list\">\n     <li data-id=\"0\">\n       <a href=\"/courses/0\">\n         <span class=\"name ellipsis\" title=\"Course 0\">Course 0</span>\n         <span class=\"subtitle ellipsis\">Enrolled as: <b>Teacher</b></span>\n       </a>\n     </li>\n     <li data-id=\"1\">\n       <a href=\"/courses/1\">\n         <span class=\"name ellipsis\" title=\"Course 1\">Course 1</span>\n         <span class=\"subtitle ellipsis\">Enrolled as: <b>Teacher</b></span>\n       </a>\n     </li>\n     <li data-id=\"10\">\n       <a href=\"/courses/10\">\n         <span class=\"name ellipsis\" title=\"Course 10\">Course 10</span>\n         <span class=\"subtitle ellipsis\">Enrolled as: <b>Teacher</b></span>\n       </a>\n     </li>\n     <li data-id=\"11\">\n       <a href=\"/courses/11\">\n         <span class=\"name ellipsis\" title=\"Course 11\">Course 11</span>\n         <span class=\"subtitle ellipsis\">Enrolled as: <b>Teacher</b></span>\n       </a>\n     </li>\n     <li data-id=\"2\">\n       <a href=\"/courses/2\">\n         <span class=\"name ellipsis\" title=\"Course 2\">Course 2</span>\n         <span class=\"subtitle ellipsis\">Enrolled as: <b>Teacher</b></span>\n       </a>\n     </li>\n     <li data-id=\"3\">\n       <a href=\"/courses/3\">\n         <span class=\"name ellipsis\" title=\"Course 3\">Course 3</span>\n         <span class=\"subtitle ellipsis\">Enrolled as: <b>Teacher</b></span>\n       </a>\n     </li>\n     <li data-id=\"4\">\n       <a href=\"/courses/4\">\n         <span class=\"name ellipsis\" title=\"Course 4\">Course 4</span>\n         <span class=\"subtitle ellipsis\">Enrolled as: <b>Teacher</b></span>\n       </a>\n     </li>\n     <li data-id=\"5\">\n       <a href=\"/courses/5\">\n         <span class=\"name ellipsis\" title=\"Course 5\">Course 5</span>\n         <span class=\"subtitle ellipsis\">Enrolled as: <b>Teacher</b></span>\n       </a>\n     </li>\n     <li data-id=\"6\">\n       <a href=\"/courses/6\">\n         <span class=\"name ellipsis\" title=\"Course 6\">Course 6</span>\n         <span class=\"subtitle ellipsis\">Enrolled as: <b>Teacher</b></span>\n       </a>\n     </li>\n     <li data-id=\"7\">\n       <a href=\"/courses/7\">\n         <span class=\"name ellipsis\" title=\"Course 7\">Course 7</span>\n         <span class=\"subtitle ellipsis\">Enrolled as: <b>Teacher</b></span>\n       </a>\n     </li>\n     <li data-id=\"8\">\n       <a href=\"/courses/8\">\n         <span class=\"name ellipsis\" title=\"Course 8\">Course 8</span>\n         <span class=\"subtitle ellipsis\">Enrolled as: <b>Teacher</b></span>\n       </a>\n     </li>\n     <li data-id=\"9\">\n       <a href=\"/courses/9\">\n         <span class=\"name ellipsis\" title=\"Course 9\">Course 9</span>\n         <span class=\"subtitle ellipsis\">Enrolled as: <b>Teacher</b></span>\n       </a>\n     </li>\n   </ul>\n </div>\n</div>");
        $('#fixtures').append(this.el);
        items = window.items = [];
        for (index = _i = 0; _i <= 100; index = ++_i) {
          items.push({
            id: index,
            shortName: "Course " + index,
            longName: "Course long " + index,
            subtitle: "Enrolled as Teacher",
            href: "/courses/" + index
          });
        }
        this.list = new CustomList(this.el.find('#customList'), items, {
          url: 'fixtures/ok.json',
          appendTarget: this.el.find('#customList')
        });
        this.list.open();
        this.lis = this.el.find('.customListItem');
        return this.clock = sinon.useFakeTimers();
      },
      teardown: function() {
        this.clock.restore();
        return this.el.remove();
      }
    });
    test('should open and close', function() {
      this.list.close();
      this.clock.tick(1);
      equal(this.list.wrapper.is(':visible'), false, 'starts hidden');
      this.list.open();
      this.clock.tick(1);
      return equal(this.list.wrapper.is(':visible'), true, 'displays on open');
    });
    test('should remove and add the first item', function() {
      var expectedLength, originalLength;

      originalLength = this.list.targetList.children().length;
      simulateClick(this.lis[0]);
      simulateClick(this.lis[1]);
      this.clock.tick(300);
      expectedLength = originalLength - 1;
      equal(this.list.pinned.length, expectedLength, 'only one item should have been removed');
      simulateClick(this.lis[0]);
      this.clock.tick(300);
      return equal(this.list.pinned.length, originalLength, 'item should be restored');
    });
    test('should cancel pending add request on remove', function() {
      var el, item;

      el = jQuery(this.lis[16]);
      this.list.add(16, el);
      this.clock.tick(300);
      ok(this.list.requests.add[16], 'create an "add" request');
      item = this.list.pinned.findBy('id', 16);
      this.list.remove(item, el);
      this.clock.tick(300);
      return equal(this.list.requests.add[16], void 0, 'delete "add" request');
    });
    test('should cancel pending remove request on add', function() {
      var el, item;

      el = jQuery(this.lis[1]);
      item = this.list.pinned.findBy('id', 1);
      this.list.remove(item, el);
      this.clock.tick(300);
      ok(this.list.requests.remove[1], 'create a "remove" request');
      this.list.add(1, el);
      this.clock.tick(300);
      return equal(this.list.requests.remove[1], void 0, 'delete "remove" request');
    });
    return test('should reset', function() {
      var length, originalLength;

      originalLength = this.list.targetList.children().length;
      simulateClick(this.lis[0]);
      this.clock.tick(300);
      ok(originalLength !== this.list.targetList.children().length, 'length should be different');
      this.list.reset();
      length = this.list.targetList.children().length;
      return equal(length, originalLength, 'targetList items restored');
    });
  });

}).call(this);

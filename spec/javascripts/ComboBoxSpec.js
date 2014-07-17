(function() {
  define(['jquery', 'compiled/widget/ComboBox', 'helpers/simulateClick'], function($, ComboBox, simulateClick) {
    var confirmSelected;

    module('ComboBox', {
      setup: function() {},
      teardown: function() {
        if (this.combobox != null) {
          return this.combobox.$el.remove();
        }
      }
    });
    confirmSelected = function(combobox, item) {
      equal(combobox.selected(), item);
      equal(combobox.$menu.val(), combobox._value(item));
      equal($('.ui-selectmenu-item', combobox.$container).text(), combobox._label(item));
      return equal($('.ui-selectmenu-item-selected .ui-selectmenu-item', combobox.$selectmenu).text(), combobox._label(item));
    };
    test('constructor: dom setup', function() {
      var i, item, items, options, selectmenuItems, _i, _len;

      items = [
        {
          label: 'label1',
          value: 'value1'
        }, {
          label: 'label2',
          value: 'value2'
        }, {
          label: 'label3',
          value: 'value3'
        }
      ];
      this.combobox = new ComboBox(items);
      ok(this.combobox.$el.hasClass('ui-combobox'));
      ok(this.combobox.$prev.hasClass('ui-combobox-prev'));
      ok(this.combobox.$next.hasClass('ui-combobox-next'));
      ok(this.combobox.$container.hasClass('ui-combobox-container'));
      ok(this.combobox.$menu[0].tagName, 'SELECT');
      ok(this.combobox.$selectmenu.hasClass, 'ui-selectmenu-menu');
      options = $('option', this.combobox.$menu);
      selectmenuItems = $('.ui-selectmenu-item', this.combobox.$selectmenu);
      equal(options.length, 3);
      equal(selectmenuItems.length, 3);
      for (i = _i = 0, _len = items.length; _i < _len; i = ++_i) {
        item = items[i];
        equal(options.eq(i).prop('value'), item.value);
        equal(options.eq(i).text(), item.label);
        equal(selectmenuItems.eq(i).text(), item.label);
      }
      return confirmSelected(this.combobox, items[0]);
    });
    test('constructor: value', function() {
      var i, item, items, options, valueFunc, _i, _len, _results;

      items = [
        {
          label: 'label1',
          id: 'id1'
        }, {
          label: 'label2',
          id: 'id2'
        }, {
          label: 'label3',
          id: 'id3'
        }
      ];
      valueFunc = function(item) {
        return item.id;
      };
      this.combobox = new ComboBox(items, {
        value: valueFunc
      });
      options = $('option', this.combobox.$menu);
      _results = [];
      for (i = _i = 0, _len = items.length; _i < _len; i = ++_i) {
        item = items[i];
        _results.push(equal(options.eq(i).prop('value'), valueFunc(item)));
      }
      return _results;
    });
    test('constructor: label', function() {
      var i, item, items, labelFunc, options, selectmenuItems, _i, _len, _results;

      items = [
        {
          name: 'name1',
          value: 'value1'
        }, {
          name: 'name2',
          value: 'value2'
        }, {
          name: 'name3',
          value: 'value3'
        }
      ];
      labelFunc = function(item) {
        return item.name;
      };
      this.combobox = new ComboBox(items, {
        label: labelFunc
      });
      options = $('option', this.combobox.$menu);
      selectmenuItems = $('.ui-selectmenu-item', this.combobox.$selectmenu);
      _results = [];
      for (i = _i = 0, _len = items.length; _i < _len; i = ++_i) {
        item = items[i];
        equal(options.eq(i).text(), labelFunc(item));
        _results.push(equal(selectmenuItems.eq(i).text(), labelFunc(item)));
      }
      return _results;
    });
    test('constructor: selected', function() {
      var items, selectedItem;

      items = [
        {
          label: 'label1',
          value: 'value1'
        }, {
          label: 'label2',
          value: 'value2'
        }, {
          label: 'label3',
          value: 'value3'
        }
      ];
      selectedItem = items[2];
      this.combobox = new ComboBox(items, {
        selected: selectedItem.value
      });
      return confirmSelected(this.combobox, selectedItem);
    });
    test('constructor: value and selected', function() {
      var items, selectedItem, valueFunc;

      items = [
        {
          label: 'label1',
          id: 'id1'
        }, {
          label: 'label2',
          id: 'id2'
        }, {
          label: 'label3',
          id: 'id3'
        }
      ];
      selectedItem = items[2];
      valueFunc = function(item) {
        return item.id;
      };
      this.combobox = new ComboBox(items, {
        value: valueFunc,
        selected: valueFunc(selectedItem)
      });
      return confirmSelected(this.combobox, selectedItem);
    });
    test('select', function() {
      var items, spy;

      items = [
        {
          label: 'label1',
          value: 'value1'
        }, {
          label: 'label2',
          value: 'value2'
        }, {
          label: 'label3',
          value: 'value3'
        }
      ];
      this.combobox = new ComboBox(items);
      spy = sinon.spy();
      this.combobox.on('change', spy);
      this.combobox.select(items[2].value);
      confirmSelected(this.combobox, items[2]);
      ok(spy.calledOnce);
      equal(spy.getCall(0).args[0], items[2]);
      spy.reset();
      this.combobox.select(items[2].value);
      return ok(!spy.called);
    });
    test('prev button', function() {
      var items, spy;

      items = [
        {
          label: 'label1',
          value: 'value1'
        }, {
          label: 'label2',
          value: 'value2'
        }, {
          label: 'label3',
          value: 'value3'
        }
      ];
      this.combobox = new ComboBox(items, {
        selected: items[1].value
      });
      spy = sinon.spy();
      this.combobox.on('change', spy);
      simulateClick(this.combobox.$prev[0]);
      confirmSelected(this.combobox, items[0]);
      ok(spy.calledOnce);
      equal(spy.getCall(0).args[0], items[0]);
      spy.reset();
      simulateClick(this.combobox.$prev[0]);
      confirmSelected(this.combobox, items[2]);
      ok(spy.calledOnce);
      return equal(spy.getCall(0).args[0], items[2]);
    });
    test('prev button: one item', function() {
      var items, spy;

      items = [
        {
          label: 'label1',
          value: 'value1'
        }
      ];
      this.combobox = new ComboBox(items);
      spy = sinon.spy();
      this.combobox.on('change', spy);
      simulateClick(this.combobox.$prev[0]);
      confirmSelected(this.combobox, items[0]);
      return ok(!spy.called);
    });
    test('next button', function() {
      var items, spy;

      items = [
        {
          label: 'label1',
          value: 'value1'
        }, {
          label: 'label2',
          value: 'value2'
        }, {
          label: 'label3',
          value: 'value3'
        }
      ];
      this.combobox = new ComboBox(items, {
        selected: items[1].value
      });
      spy = sinon.spy();
      this.combobox.on('change', spy);
      simulateClick(this.combobox.$next[0]);
      confirmSelected(this.combobox, items[2]);
      ok(spy.calledOnce);
      equal(spy.getCall(0).args[0], items[2]);
      spy.reset();
      simulateClick(this.combobox.$next[0]);
      confirmSelected(this.combobox, items[0]);
      ok(spy.calledOnce);
      return equal(spy.getCall(0).args[0], items[0]);
    });
    return test('next button: one item', function() {
      var items, spy;

      items = [
        {
          label: 'label1',
          value: 'value1'
        }
      ];
      this.combobox = new ComboBox(items);
      spy = sinon.spy();
      this.combobox.on('change', spy);
      simulateClick(this.combobox.$next[0]);
      confirmSelected(this.combobox, items[0]);
      return ok(!spy.called);
    });
  });

}).call(this);

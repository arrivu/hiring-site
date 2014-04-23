(function() {
  define(['jquery', 'compiled/jquery/serializeForm'], function($) {
    var $sampleForm;

    $sampleForm = $('<form>\n  Radio\n  <input type="radio" value="group_val_1" name="radio_group" checked />\n  <input type="radio" value="group_val_2" name="radio_group" />\n\n  Checked checkbox\n  <input type="checkbox" value="checkbox1" name="checkbox[1]" checked />\n\n  Unchecked checkbox\n  <input type="checkbox" value="checkbox2" name="checkbox[2]" />\n\n  Unchecked checkbox with hidden field (a la rails and handlebars helper)\n  <input type="hidden" value="0" name="checkbox[3]" />\n  <input type="checkbox" value="1" name="checkbox[3]" />\n\n  Text field\n  <input type="text" value="asdf" name="text" />\n\n  Disabled field\n  <input type="text" value="qwerty" name="text2" disabled />\n\n  Textarea\n  <textarea name="textarea">hello\nworld</textarea>\n\n  Select\n  <select name="select"><option>1</option><option selected>2</option></select>\n\n  Multi-select\n  <select name="multiselect" multiple>\n    <option>1</option>\n    <option selected>2</option>\n    <option selected>3</option>\n  </select>\n</form>');
    module("SerializeForm");
    return test("Serializes valid input items correctly", function() {
      var serialized;

      serialized = $sampleForm.serializeForm();
      return deepEqual(serialized, [
        {
          name: "radio_group",
          value: "group_val_1"
        }, {
          name: "checkbox[1]",
          value: "checkbox1"
        }, {
          name: "checkbox[3]",
          value: "0"
        }, {
          name: "text",
          value: "asdf"
        }, {
          name: "textarea",
          value: "hello\r\nworld"
        }, {
          name: "select",
          value: "2"
        }, {
          name: "multiselect",
          value: "2"
        }, {
          name: "multiselect",
          value: "3"
        }
      ]);
    });
  });

}).call(this);

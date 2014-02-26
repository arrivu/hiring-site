(function() {
  define(['compiled/views/MessageStudentsDialog', 'jquery', 'underscore'], function(MessageStudentsDialog, $, _) {
    module("MessageStudentsDialog", {
      setup: function() {
        this.testData = {
          context: 'The Quiz',
          recipientGroups: [
            {
              name: 'have taken the quiz',
              recipients: [
                {
                  id: 1,
                  short_name: 'bob'
                }
              ]
            }, {
              name: "haven't taken the quiz",
              recipients: [
                {
                  id: 2,
                  short_name: 'alice'
                }
              ]
            }
          ]
        };
        this.dialog = new MessageStudentsDialog(this.testData);
        this.dialog.render();
        return $('#fixtures').append(this.dialog.$el);
      },
      teardown: function() {
        this.dialog.remove();
        return $('#fixtures').empty();
      }
    });
    test("#initialize", function() {
      deepEqual(this.dialog.recipientGroups, this.testData.recipientGroups, 'saves recipientGroups');
      deepEqual(this.dialog.recipients, this.testData.recipientGroups[0].recipients, 'saves first recipientGroups recipients to be displayed');
      ok(this.dialog.title.match(this.testData.context), 'saves the title to be displayed');
      return ok(this.dialog.model, 'creates conversation automatically');
    });
    test("updates list of recipients when dropdown changes", function() {
      var html;

      this.dialog.$recipientGroupName.val("haven't taken the quiz").trigger('change');
      html = this.dialog.$el.html();
      ok(html.match('alice'), 'updated with the new list of recipients');
      return ok(!html.match('bob'), "doesn't contain old list of recipients");
    });
    test("#getFormValues returns correct values", function() {
      var body, json, messageBody, recipients;

      messageBody = 'Students please take your quiz, dang it!';
      this.dialog.$messageBody.val(messageBody);
      json = this.dialog.getFormData();
      body = json.body, recipients = json.recipients;
      strictEqual(json.body, messageBody, 'includes message body');
      strictEqual(json.recipientGroupName, void 0, "doesn't include recipientGroupName");
      return deepEqual(json.recipients, _.pluck(this.testData.recipientGroups[0].recipients, 'id'), 'includes list of ids');
    });
    return test("validateBeforeSave", function() {
      var errors;

      errors = this.dialog.validateBeforeSave({
        body: ''
      }, {});
      ok(errors.body[0].message, 'validates empty body');
      errors = this.dialog.validateBeforeSave({
        body: 'take your dang quiz'
      }, {
        recipients: []
      });
      return ok(errors.recipientGroupName[0].message, 'validates when sending to empty list of users');
    });
  });

}).call(this);

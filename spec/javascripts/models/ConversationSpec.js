(function() {
  define(['compiled/models/Conversation'], function(Conversation) {
    module("Conversation", {
      setup: function() {
        return this.conversation = new Conversation;
      }
    });
    test("#validate validates body length", function() {
      ok(this.conversation.validate({
        body: ''
      }));
      ok(this.conversation.validate({
        body: null
      }).body);
      return ok(this.conversation.validate({
        body: 'body',
        recipients: [{}]
      }) === void 0);
    });
    test("#validate validates there must be at least one recipient object", function() {
      var testData;

      testData = {
        body: 'i love testing javascript',
        recipients: [{}]
      };
      ok(this.conversation.validate(testData) === void 0);
      testData.recipients = [];
      ok(this.conversation.validate(testData).recipients);
      delete testData.recipients;
      return ok(this.conversation.validate(testData).recipients);
    });
    return test("#url is the correct API url", function() {
      return equal(this.conversation.url, '/api/v1/conversations');
    });
  });

}).call(this);

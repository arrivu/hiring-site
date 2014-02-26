(function() {
  define(['Backbone', 'jquery', 'compiled/views/ExternalTools/AddAppView', 'compiled/models/ExternalTool', 'helpers/jquery.simulate'], function(Backbone, $, AddAppView, ExternalTool) {
    var app, server, view;

    view = null;
    app = null;
    server = null;
    module("ExternalTools", {
      setup: function() {
        server = sinon.fakeServer.create();
        server.respondWith("POST", /external_tools/, [
          200, {
            "Content-Type": "application/json"
          }, JSON.stringify([
            {
              "consumer_key": "N/A",
              "created_at": "2013-05-21T08:42:47-06:00",
              "description": "Link to Google (http://google.com)",
              "domain": null,
              "id": 104,
              "name": "Redirect Tool",
              "updated_at": "2013-05-21T08:42:47-06:00",
              "url": "https://lti-examples.heroku.com/tool_redirect?url=http%3A%2F%2Fgoogle.com",
              "privacy_level": "anonymous",
              "custom_fields": {},
              "workflow_state": "anonymous",
              "vendor_help_link": null,
              "user_navigation": {
                "url": "https://lti-examples.heroku.com/tool_redirect?url=http%3A%2F%2Fgoogle.com",
                "text": "Google",
                "enabled": "true",
                "label": "Google"
              },
              "course_navigation": {
                "url": "https://lti-examples.heroku.com/tool_redirect?url=http%3A%2F%2Fgoogle.com",
                "text": "Google",
                "enabled": "true",
                "label": "Google"
              },
              "account_navigation": {
                "url": "https://lti-examples.heroku.com/tool_redirect?url=http%3A%2F%2Fgoogle.com",
                "text": "Google",
                "enabled": "true",
                "label": "Google"
              },
              "resource_selection": null,
              "editor_button": null,
              "homework_submission": null,
              "icon_url": "https://www.edu-apps.org/tools/redirect/icon.png"
            }
          ])
        ]);
        app = new Backbone.Model({
          "name": "Redirect Tool",
          "id": "redirect",
          "description": "Add links to external web resources that show up as navigation items in course.",
          "extensions": ["course_nav", "user_nav", "account_nav"],
          "launch_url": "https://lti-examples.heroku.com/tool_redirect?url={{ escape:url }}",
          "config_options": [
            {
              "name": "name",
              "description": "Link Name",
              "type": "text",
              "value": "Link",
              "required": true
            }, {
              "name": "url",
              "description": "URL Redirect",
              "type": "text",
              "value": "https://",
              "required": true
            }, {
              "name": "course_nav",
              "description": "Show in Course Navigation",
              "type": "checkbox",
              "value": "1"
            }, {
              "name": "user_nav",
              "description": "Show in User Navigation",
              "type": "checkbox",
              "value": "1"
            }, {
              "name": "account_nav",
              "description": "Show in Account Navigation",
              "type": "checkbox",
              "value": "1"
            }
          ],
          "variable_name": "{{ name }}",
          "variable_description": "Link to {{ name }} ({{ url }})",
          "ratings_count": 4,
          "comments_count": 4,
          "avg_rating": 4.5,
          "banner_url": "https://www.edu-apps.org/tools/redirect/banner.png",
          "logo_url": "https://www.edu-apps.org/tools/redirect/logo.png",
          "icon_url": "https://www.edu-apps.org/tools/redirect/icon.png",
          "config_url": "https://www.edu-apps.org/tools/redirect/config.xml"
        });
        view = new AddAppView({
          model: new ExternalTool,
          app: app
        });
        return view.render();
      },
      teardown: function() {
        return view.remove();
      }
    });
    test('AddAppView: render', function() {
      equal($.trim($('.ui-dialog-title').text()), "Add App", '"Add App" appears as dialog title');
      equal($('#canvas_app_name').val(), app.get('name'), 'Name is pre-populated from app');
      return equal($('fieldset .control-group').size(), 8, 'All fields are present (6 plus key/secret)');
    });
    return test('AddAppView: onSaveFail', function() {
      view.model.trigger('error');
      return ok(view.$('.alert.alert-error'));
    });
  });

}).call(this);

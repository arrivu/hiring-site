(function() {
  define(['compiled/collections/content_migrations/ContentCheckboxCollection', 'compiled/models/content_migrations/ContentCheckbox'], function(CheckboxCollection, CheckboxModel) {
    var createCheckboxCollection;

    module('ContentCheckboxCollectionSpec');
    createCheckboxCollection = function(properties) {
      var models, options;

      properties || (properties = {});
      models = properties.models || new CheckboxModel({
        id: 42
      });
      options = properties.options || {
        migrationID: 1,
        courseID: 2
      };
      return new CheckboxCollection(models, options);
    };
    test('url is going to the correct api endpoint', function() {
      var checkboxCollection, courseID, endpointURL, migrationID;

      courseID = 10;
      migrationID = 20;
      checkboxCollection = createCheckboxCollection({
        options: {
          migrationID: migrationID,
          courseID: courseID
        }
      });
      endpointURL = "/api/v1/courses/" + courseID + "/content_migrations/" + migrationID + "/selective_data";
      return equal(checkboxCollection.url(), endpointURL, "Endpoint url is correct");
    });
    test('contains ContentCheckboxModel\'s ', function() {
      var model, modelInstance;

      model = createCheckboxCollection().model;
      modelInstance = new model();
      return ok(modelInstance instanceof CheckboxModel, "Collection contains instances of ContentCheckboxModels");
    });
    test('has a courseID', function() {
      return ok(isFinite(Number(createCheckboxCollection({
        options: {
          courseID: "23"
        }
      }).courseID)), "Has a courseID number");
    });
    return test('has a migrationID', function() {
      return ok(isFinite(Number(createCheckboxCollection({
        options: {
          migrationID: "13"
        }
      }).migrationID)), "Has a migrationID number");
    });
  });

}).call(this);

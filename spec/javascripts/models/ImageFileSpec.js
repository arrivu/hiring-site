(function() {
  define(['compiled/models/ImageFile', 'use!vendor/FileAPI/FileAPI.min'], function(ImageFile, FileAPI) {
    var file, filterFilesStub, getFilesStub, model;

    model = null;
    file = {};
    getFilesStub = null;
    filterFilesStub = null;
    module('ImageFile', {
      setup: function() {
        model = new ImageFile(null, {
          preflightUrl: '/preflight'
        });
        file = {};
        getFilesStub = sinon.stub(FileAPI, 'getFiles', function() {
          return [file];
        });
        return filterFilesStub = sinon.stub(FileAPI, 'filterFiles', function(f, cb) {
          return cb(file, file);
        });
      },
      teardown: function() {
        getFilesStub.restore();
        return filterFilesStub.restore();
      }
    });
    return test('returns a useful deferred', function() {
      file = {
        type: "text/plain",
        size: 1234
      };
      equal(model.loadFile().state(), "rejected");
      file = {
        type: "image/foo",
        size: 1234
      };
      equal(model.loadFile().state(), "rejected");
      file = {
        type: "image/png",
        size: 123546
      };
      equal(model.loadFile().state(), "rejected");
      file = {
        type: "image/png",
        size: 12345
      };
      equal(model.loadFile().state(), "rejected");
      file = {
        type: "image/png",
        size: 12345,
        width: 1000,
        height: 100
      };
      equal(model.loadFile().state(), "rejected");
      file = {
        type: "image/png",
        size: 12345,
        width: 100,
        height: 100
      };
      return equal(model.loadFile().state(), "resolved");
    });
  });

}).call(this);

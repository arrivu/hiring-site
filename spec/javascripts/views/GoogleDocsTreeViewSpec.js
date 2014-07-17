(function() {
  define(['compiled/views/GoogleDocsTreeView'], function(GoogleDocsTreeView) {
    var file1, fileData, folderData;

    file1 = {
      name: 'File 1',
      extension: 'tst',
      document_id: '12345',
      alternate_url: {
        href: '#'
      }
    };
    fileData = {
      files: [file1]
    };
    folderData = {
      folders: [
        {
          name: 'Folder 1',
          files: [file1]
        }
      ]
    };
    module('GoogleDocsTreeView', {
      setup: function() {},
      teardown: function() {}
    });
    test('renders a top level file', function() {
      var tree;

      tree = new GoogleDocsTreeView({
        model: fileData
      });
      tree.render();
      return equal(tree.$el.html().match(/>File 1<\/span>/).length, 1);
    });
    test('gives the file link a title', function() {
      var tree;

      tree = new GoogleDocsTreeView({
        model: fileData
      });
      tree.render();
      return equal(tree.$el.html().match(/title="View in Separate Window"/).length, 1);
    });
    test('renders a folder', function() {
      var tree;

      tree = new GoogleDocsTreeView({
        model: folderData
      });
      tree.render();
      return equal(tree.$el.html().match(/<li class="folder.*\n\s+Folder 1/).length, 1);
    });
    test('gives a nested file link a title', function() {
      var tree;

      tree = new GoogleDocsTreeView({
        model: folderData
      });
      tree.render();
      return equal(tree.$el.html().match(/title="View in Separate Window"/).length, 1);
    });
    test('activateFile triggers an event', function() {
      var tree;

      tree = new GoogleDocsTreeView({
        model: fileData
      });
      tree.on('activate-file', function(file_id) {
        return equal(file_id, file1.document_id);
      });
      tree.render();
      return tree.$('li.file').click();
    });
    return test('activateFolder delegates through to clicking the sign', function() {
      var tree;

      expect(1);
      tree = new GoogleDocsTreeView({
        model: folderData
      });
      tree.render();
      tree.$(".sign").on('click', function() {
        return ok('got clicked');
      });
      return tree.$('li.folder').click();
    });
  });

}).call(this);

(function() {
  define(['jquery', 'compiled/models/WikiPage', 'compiled/views/wiki/WikiPageEditView', 'wikiSidebar'], function($, WikiPage, WikiPageEditView, wikiSidebar) {
    var setupUnsavedChangesTest, testRights;

    module('WikiPageEditView:Init', {
      setup: function() {
        this.initStub = sinon.stub(wikiSidebar, 'init');
        this.scrollSidebarStub = sinon.stub($, 'scrollSidebar');
        this.attachWikiEditorStub = sinon.stub(wikiSidebar, 'attachToEditor');
        return this.attachWikiEditorStub.returns({
          show: sinon.stub()
        });
      },
      teardown: function() {
        this.scrollSidebarStub.restore();
        this.initStub.restore();
        return this.attachWikiEditorStub.restore();
      }
    });
    test('init wiki sidebar during render', function() {
      var wikiPageEditView;

      wikiPageEditView = new WikiPageEditView;
      wikiPageEditView.render();
      return ok(this.initStub.calledOnce, 'Called wikiSidebar init once');
    });
    test('scroll sidebar during render', function() {
      var wikiPageEditView;

      wikiPageEditView = new WikiPageEditView;
      wikiPageEditView.render();
      return ok(this.scrollSidebarStub.calledOnce, 'Called scrollSidebar once');
    });
    test('wiki body gets attached to the wikisidebar', function() {
      var wikiPageEditView;

      wikiPageEditView = new WikiPageEditView;
      wikiPageEditView.render();
      return ok(this.attachWikiEditorStub.calledOnce, 'Attached wikisidebar to body');
    });
    module('WikiPageEditView:UnsavedChanges');
    setupUnsavedChangesTest = function(test, attributes) {
      var setup;

      setup = function() {
        var bodyInput, editorBox, model, teardown;

        this.stub($, 'scrollSidebar');
        this.stub(wikiSidebar, 'init');
        this.stub(wikiSidebar, 'attachToEditor').returns({
          show: this.stub()
        });
        this.wikiPage = new WikiPage(attributes);
        this.view = new WikiPageEditView({
          model: this.wikiPage
        });
        this.view.$el.appendTo('#fixtures');
        this.view.render();
        this.titleInput = this.view.$el.find('[name=title]');
        this.bodyInput = this.view.$el.find('[name=body]');
        model = this.wikiPage;
        bodyInput = this.bodyInput;
        editorBox = bodyInput.editorBox;
        this.stub($.fn, 'editorBox', function(options) {
          if (options === 'is_dirty') {
            return bodyInput.val() !== model.get('body');
          } else {
            return editorBox.apply(this, arguments);
          }
        });
        teardown = this.teardown;
        return this.teardown = function() {
          teardown.apply(this, arguments);
          this.view.remove();
          return $(window).off('beforeunload');
        };
      };
      return setup.call(test, attributes);
    };
    test('check for unsaved changes on new model', function() {
      setupUnsavedChangesTest(this, {
        title: '',
        body: ''
      });
      this.titleInput.val('blah');
      ok(this.view.getFormData().title === 'blah', "blah");
      ok(this.view.hasUnsavedChanges(), 'Changed title');
      this.titleInput.val('');
      ok(!this.view.hasUnsavedChanges(), 'Unchanged title');
      this.bodyInput.val('bloo');
      ok(this.view.hasUnsavedChanges(), 'Changed body');
      this.bodyInput.val('');
      return ok(!this.view.hasUnsavedChanges(), 'Unchanged body');
    });
    test('check for unsaved changes on model with data', function() {
      setupUnsavedChangesTest(this, {
        title: 'nooo',
        body: 'blargh'
      });
      ok(!this.view.hasUnsavedChanges(), 'No changes');
      this.titleInput.val('');
      ok(this.view.hasUnsavedChanges(), 'Changed title');
      this.titleInput.val('nooo');
      ok(!this.view.hasUnsavedChanges(), 'Unchanged title');
      this.bodyInput.val('');
      return ok(this.view.hasUnsavedChanges(), 'Changed body');
    });
    test('warn on cancel if unsaved changes', function() {
      setupUnsavedChangesTest(this, {
        title: 'nooo',
        body: 'blargh'
      });
      this.spy(this.view, 'trigger');
      this.stub(window, 'confirm');
      this.titleInput.val('mwhaha');
      window.confirm.returns(false);
      this.view.$el.find('.cancel').click();
      ok(window.confirm.calledOnce, 'Warn on cancel');
      ok(!this.view.trigger.calledWith('cancel'), "Don't trigger cancel if declined");
      window.confirm.reset();
      this.view.trigger.reset();
      window.confirm.returns(true);
      this.view.$el.find('.cancel').click();
      ok(window.confirm.calledOnce, 'Warn on cancel again');
      return ok(this.view.trigger.calledWith('cancel'), 'Do trigger cancel if accepted');
    });
    test('warn on leaving if unsaved changes', function() {
      setupUnsavedChangesTest(this, {
        title: 'nooo',
        body: 'blargh'
      });
      strictEqual($(window).triggerHandler('beforeunload'), void 0, "No warning if not changed");
      this.titleInput.val('mwhaha');
      return ok($(window).triggerHandler('beforeunload') !== void 0, "Returns warning if changed");
    });
    module('WikiPageEditView:Validate');
    test('validation of the title is only performed if the title is present', function() {
      var errors, view;

      view = new WikiPageEditView;
      errors = view.validateFormData({
        body: 'blah'
      });
      strictEqual(errors['title'], void 0, 'no error when title is omitted');
      errors = view.validateFormData({
        title: 'blah',
        body: 'blah'
      });
      strictEqual(errors['title'], void 0, 'no error when title is present');
      errors = view.validateFormData({
        title: '',
        body: 'blah'
      });
      ok(errors['title'], 'error when title is present, but blank');
      return ok(errors['title'][0].message, 'error message when title is present, but blank');
    });
    module('WikiPageEditView:JSON');
    testRights = function(subject, options) {
      return test("" + subject, function() {
        var json, key, model, view, _results;

        model = new WikiPage(options.attributes, {
          contextAssetString: options.contextAssetString
        });
        view = new WikiPageEditView({
          model: model,
          WIKI_RIGHTS: options.WIKI_RIGHTS,
          PAGE_RIGHTS: options.PAGE_RIGHTS
        });
        json = view.toJSON();
        if (options.IS) {
          for (key in options.IS) {
            strictEqual(json.IS[key], options.IS[key], "IS." + key);
          }
        }
        if (options.CAN) {
          for (key in options.CAN) {
            strictEqual(json.CAN[key], options.CAN[key], "CAN." + key);
          }
        }
        if (options.SHOW) {
          _results = [];
          for (key in options.SHOW) {
            _results.push(strictEqual(json.SHOW[key], options.SHOW[key], "SHOW." + key));
          }
          return _results;
        }
      });
    };
    testRights('IS (teacher)', {
      attributes: {
        editing_roles: 'teachers'
      },
      IS: {
        TEACHER_ROLE: true,
        STUDENT_ROLE: false,
        MEMBER_ROLE: false,
        ANYONE_ROLE: false
      }
    });
    testRights('IS (student)', {
      attributes: {
        editing_roles: 'teachers,students'
      },
      IS: {
        TEACHER_ROLE: false,
        STUDENT_ROLE: true,
        MEMBER_ROLE: false,
        ANYONE_ROLE: false
      }
    });
    testRights('IS (members)', {
      attributes: {
        editing_roles: 'members'
      },
      IS: {
        TEACHER_ROLE: false,
        STUDENT_ROLE: false,
        MEMBER_ROLE: true,
        ANYONE_ROLE: false
      }
    });
    testRights('IS (course anyone)', {
      attributes: {
        editing_roles: 'teachers,students,public'
      },
      IS: {
        TEACHER_ROLE: false,
        STUDENT_ROLE: false,
        MEMBER_ROLE: false,
        ANYONE_ROLE: true
      }
    });
    testRights('IS (group anyone)', {
      attributes: {
        editing_roles: 'members,public'
      },
      IS: {
        TEACHER_ROLE: false,
        STUDENT_ROLE: false,
        MEMBER_ROLE: false,
        ANYONE_ROLE: true
      }
    });
    testRights('IS (null)', {
      IS: {
        TEACHER_ROLE: true,
        STUDENT_ROLE: false,
        MEMBER_ROLE: false,
        ANYONE_ROLE: false
      }
    });
    testRights('CAN/SHOW (manage course)', {
      contextAssetString: 'course_73',
      attributes: {
        url: 'test'
      },
      WIKI_RIGHTS: {
        manage: true
      },
      PAGE_RIGHTS: {
        read: true,
        update: true,
        "delete": true
      },
      CAN: {
        PUBLISH: true,
        DELETE: true,
        EDIT_TITLE: true,
        EDIT_ROLES: true
      },
      SHOW: {
        COURSE_ROLES: true
      }
    });
    testRights('CAN/SHOW (manage group)', {
      contextAssetString: 'group_73',
      WIKI_RIGHTS: {
        manage: true
      },
      PAGE_RIGHTS: {
        read: true
      },
      CAN: {
        PUBLISH: false,
        DELETE: false,
        EDIT_TITLE: true,
        EDIT_ROLES: true
      },
      SHOW: {
        COURSE_ROLES: false
      }
    });
    testRights('CAN/SHOW (update_content)', {
      contextAssetString: 'course_73',
      attributes: {
        url: 'test'
      },
      WIKI_RIGHTS: {
        read: true
      },
      PAGE_RIGHTS: {
        read: true,
        update_content: true
      },
      CAN: {
        PUBLISH: false,
        DELETE: false,
        EDIT_TITLE: false,
        EDIT_ROLES: false
      }
    });
    return testRights('CAN/SHOW (null)', {
      attributes: {
        url: 'test'
      },
      CAN: {
        PUBLISH: false,
        DELETE: false,
        EDIT_TITLE: false,
        EDIT_ROLES: false
      }
    });
  });

}).call(this);

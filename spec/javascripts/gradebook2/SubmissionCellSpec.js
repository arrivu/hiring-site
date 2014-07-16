(function() {
  define(['compiled/gradebook2/SubmissionCell', 'str/htmlEscape', 'jquery'], function(SubmissionCell, htmlEscape, $) {
    var dangerousHTML, escapedDangerousHTML;

    dangerousHTML = '"><img src=/ onerror=alert(document.cookie);>';
    escapedDangerousHTML = htmlEscape(dangerousHTML);
    module("SubmissionCell", {
      setup: function() {
        this.opts = {
          item: {
            'whatever': {}
          },
          column: {
            field: 'whatever',
            object: {}
          },
          container: $('#fixtures')[0]
        };
        return this.cell = new SubmissionCell(this.opts);
      },
      teardown: function() {
        return $('#fixtures').empty();
      }
    });
    test("#applyValue escapes html in passed state", function() {
      var item, state;

      item = {
        whatever: {
          grade: '1'
        }
      };
      state = dangerousHTML;
      sinon.stub(this.cell, 'postValue');
      this.cell.applyValue(item, state);
      return equal(item.whatever.grade, escapedDangerousHTML);
    });
    test("#loadValue escapes html", function() {
      this.opts.item.whatever.grade = dangerousHTML;
      this.cell.loadValue();
      equal(this.cell.$input.val(), escapedDangerousHTML);
      return equal(this.cell.$input[0].defaultValue, escapedDangerousHTML);
    });
    test("#class.formatter rounds numbers if they are numbers", function() {
      var formattedResponse;

      sinon.stub(SubmissionCell.prototype, 'cellWrapper').withArgs(0.67).returns('ok');
      formattedResponse = SubmissionCell.formatter(0, 0, {
        grade: 0.666
      });
      SubmissionCell.prototype.cellWrapper.restore();
      return equal(formattedResponse, 'ok');
    });
    return test("#class.formatter gives the value to the formatter if submission.grade isnt a parseable number", function() {
      var formattedResponse;

      sinon.stub(SubmissionCell.prototype, 'cellWrapper').withArgs('happy').returns('ok');
      formattedResponse = SubmissionCell.formatter(0, 0, {
        grade: 'happy'
      });
      SubmissionCell.prototype.cellWrapper.restore();
      return equal(formattedResponse, 'ok');
    });
  });

}).call(this);

(function() {
  define(['vendor/date'], function() {
    module('Date');
    test('Date.parse', function() {
      var dateString, examples, expectedDate, utc, _results;

      utc = function() {
        return new Date(Date.UTC.apply(Date, arguments));
      };
      examples = {
        "Wed May 2 2012 00:00:00 MST": utc(2012, 4, 2, 7, 0, 0),
        "Wed May 2 2012 00:00:00 MDT": utc(2012, 4, 2, 6, 0, 0),
        "2012-05-02T00:00:00-06:00": utc(2012, 4, 2, 6, 0, 0),
        "Wed May 2 2012 00:00:00 UTC": utc(2012, 4, 2, 0, 0, 0),
        "Wed May 2 2012 00:00:00 GMT": utc(2012, 4, 2, 0, 0, 0),
        "2012-05-02T00:00:00Z": utc(2012, 4, 2, 0, 0, 0),
        "2012-05-02T00:00:00-0000": utc(2012, 4, 2, 0, 0, 0),
        "2012-05-02T00:00:00+0000": utc(2012, 4, 2, 0, 0, 0),
        "2012-05-02T00:00:00+00:00": utc(2012, 4, 2, 0, 0, 0),
        "2012-05-02T00:00:00-00:00": utc(2012, 4, 2, 0, 0, 0),
        "2012-05-02T00:00:00+02:30": utc(2012, 4, 1, 21, 30, 0),
        "2012-05-02T00:00:00-02:30": utc(2012, 4, 2, 2, 30, 0),
        "2012-05-02T00:00:00+01:01": utc(2012, 4, 1, 22, 59, 0),
        "2012-05-02T00:00:00-01:01": utc(2012, 4, 2, 1, 1, 0),
        "2012-05-02T00:00:00+01:59": utc(2012, 4, 1, 22, 1, 0),
        "2012-05-02T00:00:00-01:59": utc(2012, 4, 2, 1, 59, 0),
        "2012-05-02T00:00:00+00:01": utc(2012, 4, 1, 23, 59, 0),
        "2012-05-02T00:00:00-00:01": utc(2012, 4, 2, 0, 1, 0),
        "2012-11-04T01:00:00-06:00": utc(2012, 10, 4, 7, 0, 0)
      };
      _results = [];
      for (dateString in examples) {
        expectedDate = examples[dateString];
        _results.push(equal(Date.parse(dateString).valueOf(), expectedDate.valueOf()));
      }
      return _results;
    });
    test('date.getUTCOffset', function() {
      var date, examples, expectedResult, offset, _results;

      examples = {
        ' 360': '-0600',
        ' 420': '-0700',
        '   0': '+0000',
        '-150': '+0230',
        ' 150': '-0230',
        ' -61': '+0101',
        '  61': '-0101',
        '-119': '+0159',
        ' 119': '-0159',
        '  -1': '+0001',
        '   1': '-0001'
      };
      _results = [];
      for (offset in examples) {
        expectedResult = examples[offset];
        date = new Date;
        sinon.stub(date, 'getTimezoneOffset').returns(Number(offset));
        _results.push(equal(date.getUTCOffset(), expectedResult));
      }
      return _results;
    });
    test('date.add* at DST-end', function() {
      var date;

      date = new Date(2012, 10, 4, 0, 59, 59, 999);
      ok(date.clone().addMilliseconds(1).equals(new Date(date.clone().setUTCMilliseconds(1000))));
      ok(date.clone().addSeconds(1).equals(new Date(date.clone().setUTCSeconds(60))));
      ok(date.clone().addMinutes(1).equals(new Date(date.clone().setUTCMinutes(60))));
      return ok(date.clone().addHours(1).equals(new Date(date.clone().setUTCHours(date.getUTCHours() + 1))));
    });
    return test('date.set at DST-end', function() {
      var date;

      date = new Date(2012, 10, 4, 0, 0, 0);
      date.set({
        hour: 14
      });
      ok(date.getHours() === 14);
      date.set({
        hour: 1
      });
      return ok(date.getHours() === 1);
    });
  });

}).call(this);

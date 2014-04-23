(function() {
  define(['Backbone', 'compiled/models/DateGroup'], function(Backbone, DateGroup) {
    module('DateGroup', {
      setup: function() {}
    });
    test('default title is set', function() {
      var dueAt, model;

      dueAt = new Date("2013-08-20 11:13:00");
      model = new DateGroup({
        due_at: dueAt,
        title: "Summer session"
      });
      equal(model.get("title"), 'Summer session');
      model = new DateGroup({
        due_at: dueAt
      });
      return equal(model.get("title"), 'Everyone else');
    });
    test("#dueAt parses due_at to a date", function() {
      var model;

      model = new DateGroup({
        due_at: "2013-08-20 11:13:00"
      });
      return equal(model.dueAt().constructor, Date);
    });
    test("#dueAt doesn't parse null date", function() {
      var model;

      model = new DateGroup({
        due_at: null
      });
      return equal(model.dueAt(), null);
    });
    test("#unlockAt parses unlock_at to a date", function() {
      var model;

      model = new DateGroup({
        unlock_at: "2013-08-20 11:13:00"
      });
      return equal(model.unlockAt().constructor, Date);
    });
    test("#unlockAt doesn't parse null date", function() {
      var model;

      model = new DateGroup({
        unlock_at: null
      });
      return equal(model.unlockAt(), null);
    });
    test("#lockAt parses lock_at to a date", function() {
      var model;

      model = new DateGroup({
        lock_at: "2013-08-20 11:13:00"
      });
      return equal(model.lockAt().constructor, Date);
    });
    test("#lockAt doesn't parse null date", function() {
      var model;

      model = new DateGroup({
        lock_at: null
      });
      return equal(model.lockAt(), null);
    });
    test("#alwaysAvailable if both unlock and lock dates aren't set", function() {
      var model;

      model = new DateGroup({
        unlock_at: null,
        lock_at: null
      });
      return ok(model.alwaysAvailable());
    });
    test("#alwaysAvailable is false if unlock date is set", function() {
      var model;

      model = new DateGroup({
        unlock_at: "2013-08-20 11:13:00",
        lock_at: null
      });
      return ok(!model.alwaysAvailable());
    });
    test("#alwaysAvailable is false if lock date is set", function() {
      var model;

      model = new DateGroup({
        unlock_at: null,
        lock_at: "2013-08-20 11:13:00"
      });
      return ok(!model.alwaysAvailable());
    });
    test("#available is true if always available", function() {
      var model;

      model = new DateGroup({
        unlock_at: null,
        lock_at: null
      });
      return ok(model.available());
    });
    test("#available is true if no lock date and unlock date has passed", function() {
      var model;

      model = new DateGroup({
        unlock_at: "2013-08-20 11:13:00",
        now: "2013-08-30 00:00:00"
      });
      return ok(model.available());
    });
    test("#available is false if not unlocked yet", function() {
      var model;

      model = new DateGroup({
        unlock_at: "2013-08-20 11:13:00",
        now: "2013-08-19 00:00:00"
      });
      return ok(!model.available());
    });
    test("#available is false if locked", function() {
      var model;

      model = new DateGroup({
        lock_at: "2013-08-20 11:13:00",
        now: "2013-08-30 00:00:00"
      });
      return ok(!model.available());
    });
    test("#pending is true if not unlocked yet", function() {
      var model;

      model = new DateGroup({
        unlock_at: "2013-08-20 11:13:00",
        now: "2013-08-19 00:00:00"
      });
      return ok(model.pending());
    });
    test("#pending is false if no unlock date", function() {
      var model;

      model = new DateGroup({
        unlock_at: null
      });
      return ok(!model.pending());
    });
    test("#pending is false if unlocked", function() {
      var model;

      model = new DateGroup({
        unlock_at: "2013-08-20 11:13:00",
        now: "2013-08-30 00:00:00"
      });
      return ok(!model.pending());
    });
    test("#open is true if has a lock date but not locked yet", function() {
      var model;

      model = new DateGroup({
        lock_at: "2013-08-20 11:13:00",
        now: "2013-08-10 00:00:00"
      });
      return ok(model.open());
    });
    test("#open is false without an unlock date", function() {
      var model;

      model = new DateGroup({
        unlock_at: null
      });
      return ok(!model.open());
    });
    test("#open is false if not unlocked yet", function() {
      var model;

      model = new DateGroup({
        unlock_at: "2013-08-20 11:13:00",
        now: "2013-08-19 00:00:00"
      });
      return ok(!model.open());
    });
    test("#closed is true if not locked", function() {
      var model;

      model = new DateGroup({
        lock_at: "2013-08-20 11:13:00",
        now: "2013-08-30 00:00:00"
      });
      return ok(model.closed());
    });
    test("#closed is false if no lock date", function() {
      var model;

      model = new DateGroup({
        lock_at: null
      });
      return ok(!model.closed());
    });
    test("#closed is false if unlocked has passed", function() {
      var model;

      model = new DateGroup({
        lock_at: "2013-08-20 11:13:00",
        now: "2013-08-19 00:00:00"
      });
      return ok(!model.closed());
    });
    test("#toJSON includes dueFor", function() {
      var json, model;

      model = new DateGroup({
        title: "Summer session"
      });
      json = model.toJSON();
      return equal(json.dueFor, "Summer session");
    });
    test("#toJSON includes dueAt", function() {
      var json, model;

      model = new DateGroup({
        due_at: "2013-08-20 11:13:00"
      });
      json = model.toJSON();
      return equal(json.dueAt.constructor, Date);
    });
    test("#toJSON includes unlockAt", function() {
      var json, model;

      model = new DateGroup({
        unlock_at: "2013-08-20 11:13:00"
      });
      json = model.toJSON();
      return equal(json.unlockAt.constructor, Date);
    });
    test("#toJSON includes lockAt", function() {
      var json, model;

      model = new DateGroup({
        lock_at: "2013-08-20 11:13:00"
      });
      json = model.toJSON();
      return equal(json.lockAt.constructor, Date);
    });
    test("#toJSON includes available", function() {
      var json, model;

      model = new DateGroup;
      json = model.toJSON();
      return equal(json.available, true);
    });
    test("#toJSON includes pending", function() {
      var json, model;

      model = new DateGroup({
        unlock_at: "2013-08-20 11:13:00",
        now: "2013-08-19 00:00:00"
      });
      json = model.toJSON();
      return equal(json.pending, true);
    });
    test("#toJSON includes open", function() {
      var json, model;

      model = new DateGroup({
        lock_at: "2013-08-20 11:13:00",
        now: "2013-08-10 00:00:00"
      });
      json = model.toJSON();
      return equal(json.open, true);
    });
    return test("#toJSON includes closed", function() {
      var json, model;

      model = new DateGroup({
        lock_at: "2013-08-20 11:13:00",
        now: "2013-08-30 00:00:00"
      });
      json = model.toJSON();
      return equal(json.closed, true);
    });
  });

}).call(this);

(function() {
  define(['jquery', 'underscore', 'compiled/behaviors/SyllabusBehaviors', 'compiled/collections/SyllabusCollection', 'compiled/collections/SyllabusCalendarEventsCollection', 'compiled/collections/SyllabusAppointmentGroupsCollection', 'compiled/views/courses/SyllabusView', 'spec/javascripts/views/SyllabusViewPrerendered', 'helpers/fakeENV', 'helpers/jquery.simulate'], function($, _, SyllabusBehaviors, SyllabusCollection, SyllabusCalendarEventsCollection, SyllabusAppointmentGroupsCollection, SyllabusView, SyllabusViewPrerendered) {
    var setupServerResponses;

    setupServerResponses = function() {
      var appointment_groups, appointment_groups_endpoint, assignments, calendar_events_endpoint, events, server;

      server = sinon.fakeServer.create();
      assignments = SyllabusViewPrerendered.assignments;
      events = SyllabusViewPrerendered.events;
      calendar_events_endpoint = function(request) {
        var links, more, response;

        if (request.url.match(/.*\?.*\btype=assignment\b/)) {
          response = assignments.slice(0, 2);
          assignments = assignments.slice(2);
          more = assignments.length > 0;
        } else if (request.url.match(/.*\?.*\btype=event\b/)) {
          response = events.slice(0, 2);
          events = events.slice(2);
          more = events.length > 0;
        }
        links = "<" + request.url + ">; rel=\"first\"";
        if (more) {
          links += ",<" + request.url + ">; rel=\"next\"";
        }
        return request.respond(200, {
          'Content-Type': 'application/json',
          'Link': links
        }, JSON.stringify(response));
      };
      appointment_groups = SyllabusViewPrerendered.appointment_groups;
      appointment_groups_endpoint = function(request) {
        var links, more, response;

        response = appointment_groups.slice(0, 2);
        appointment_groups = appointment_groups.slice(2);
        more = appointment_groups.length > 0;
        links = "<" + request.url + ">; rel=\"first\"";
        if (more) {
          links += ",<" + request.url + ">; rel=\"next\"";
        }
        return request.respond(200, {
          'Content-Type': 'application/json',
          'Link': links
        }, JSON.stringify(response));
      };
      server.respondWith(/\/api\/v1\/calendar_events($|\?)/, calendar_events_endpoint);
      server.respondWith(/\/api\/v1\/appointment_groups($|\?)/, appointment_groups_endpoint);
      return server;
    };
    module('Syllabus', {
      setup: function() {
        var $fixtures, acollection, collections;

        this.server = setupServerResponses();
        this.getUserOffset = sinon.stub($, 'getUserOffset', function() {
          return -7 * 60;
        });
        this.clock = sinon.useFakeTimers(new Date(2012, 0, 23, 15, 30).getTime());
        $fixtures = $('#fixtures');
        this.jumpToToday = $(SyllabusViewPrerendered.jumpToToday);
        this.jumpToToday.appendTo($fixtures);
        this.miniMonth = $(SyllabusViewPrerendered.miniMonth);
        this.miniMonth.appendTo($fixtures);
        this.syllabusContainer = $(SyllabusViewPrerendered.syllabusContainer);
        this.syllabusContainer.appendTo($fixtures);
        collections = [new SyllabusCalendarEventsCollection([ENV.context_asset_string], 'event'), new SyllabusCalendarEventsCollection([ENV.context_asset_string], 'assignment'), new SyllabusAppointmentGroupsCollection([ENV.context_asset_string], 'reservable'), new SyllabusAppointmentGroupsCollection([ENV.context_asset_string], 'manageable')];
        acollection = new SyllabusCollection(collections);
        _.map(collections, function(collection) {
          var error, success;

          error = function() {
            return ok(false, 'ajax call failed');
          };
          success = function() {
            if (collection.canFetch('next')) {
              return collection.fetch({
                page: 'next',
                success: success,
                error: error
              });
            }
          };
          return collection.fetch({
            data: {
              per_page: 2
            },
            success: success,
            error: error
          });
        });
        this.server.respond();
        return this.view = new SyllabusView({
          el: '#syllabusContainer',
          collection: acollection
        });
      },
      teardown: function() {
        this.syllabusContainer.remove();
        this.miniMonth.remove();
        this.jumpToToday.remove();
        this.clock.restore();
        this.getUserOffset.restore();
        return this.server.restore();
      },
      render: function() {
        this.view.render();
        SyllabusBehaviors.bindToMiniCalendar();
        return SyllabusBehaviors.bindToSyllabus();
      },
      renderAssertions: function() {
        var actual, assignments, dates, events, expected, syllabus;

        expect(15);
        syllabus = $('#syllabus');
        ok(syllabus.length, 'syllabus - syllabus added to the dom');
        ok(syllabus.is(':visible'), 'syllabus - syllabus visible');
        dates = $('tr.date', syllabus);
        equal(dates.length, 6, 'dates - dates coalesce');
        assignments = $('tr.syllabus_assignment', dates);
        equal(assignments.length, 10, 'events - all assignments rendered');
        if (this.view.can_read) {
          equal($('td.name a', assignments).length, 10, 'events - link rendered for each assignment');
        } else {
          equal($('td.name a', assignments).length, 0, 'events - link not rendered for each assignment');
        }
        events = $('tr.syllabus_event', dates);
        equal(events.length, 6, 'events - all events rendered');
        if (this.view.can_read && this.view.is_valid_user) {
          equal($('td.name a', events).length, 6, 'events - link rendered for each event');
        } else {
          equal($('td.name a', events).length, 0, 'events - link not rendered for each event');
        }
        expected = $('#mini_day_2012_01_01, #mini_day_2012_01_11, #mini_day_2012_01_23, #mini_day_2012_01_30, #mini_day_2012_01_31');
        actual = $('.mini_calendar_day.has_event');
        equal(expected.length, 5, 'mini calendar - expected dates with events found');
        deepEqual(actual.toArray(), expected.toArray(), 'mini calendar - dates with events highlighted');
        expected = $('#mini_day_2012_01_23');
        actual = $('.mini_calendar_day.related');
        equal(expected.length, 1, 'today - today found');
        deepEqual(actual.toArray(), expected.toArray(), 'today - today highlighted');
        expected = $('.events_2012_01_23');
        actual = $('tr.date.related');
        equal(expected.length, 1, 'today - today\'s events found');
        deepEqual(actual.toArray(), expected.toArray(), 'today - today\'s events highlighted');
        expected = $('.events_2012_01_01, .events_2012_01_11');
        actual = $('tr.date.date_passed');
        equal(expected.length, 2, 'passed events - passed events found');
        return deepEqual(actual.toArray(), expected.toArray(), 'passed events - events before today marked as passed');
      }
    });
    test('render (user public course)', function() {
      this.view.can_read = true;
      this.view.is_valid_user = true;
      this.render();
      return this.renderAssertions();
    });
    test('render (anonymous public course)', function() {
      this.view.can_read = true;
      this.view.is_valid_user = false;
      this.render();
      return this.renderAssertions();
    });
    test('render (user public syllabus)', function() {
      this.view.can_read = false;
      this.view.is_valid_user = true;
      this.render();
      return this.renderAssertions();
    });
    test('render (anonymous public syllabus)', function() {
      this.view.can_read = false;
      this.view.is_valid_user = false;
      this.render();
      return this.renderAssertions();
    });
    test('syllabus interaction', function() {
      var actual, assignment, date, event, expected, override, undated;

      expect(14);
      this.view.is_public_course = true;
      this.view.can_participate = true;
      this.render();
      event = $('.events_2012_01_11');
      date = $('#mini_day_2012_01_11');
      equal(event.length, 1, 'hover dated syllabus row - event found');
      equal(date.length, 1, 'hover dated syllabus row - mini calendar day found');
      event.simulate('mouseover');
      expected = event;
      actual = $('tr.date.related');
      deepEqual(actual.toArray(), expected.toArray(), 'hover dated syllabus row - event highlighted');
      expected = date;
      actual = $('.mini_calendar_day.related');
      deepEqual(actual.toArray(), expected.toArray(), 'hover dated syllabus row - mini calendar day highlighted');
      undated = $('tr.date:not(.events_2012_01_01, .events_2012_01_11, .events_2012_01_23, .events_2012_01_30, .events_2012_01_31)');
      equal(undated.length, 1, 'hover undated syllabus row - row found');
      undated.simulate('mouseover');
      expected = [];
      actual = $('tr.date.related');
      deepEqual(actual.toArray(), expected, 'hover undated syllabus row - no events highlighted');
      expected = [];
      actual = $('.mini_calendar_day.related');
      deepEqual(actual.toArray(), expected, 'hover undated syllabus row - no mini calendar days highlighted');
      assignment = $('tr.related-assignment_1:not(.special_date)');
      equal(assignment.length, 1, 'hover event - assignment event found');
      assignment.simulate('mouseover');
      expected = $('tr.related-assignment_1.special_date');
      equal(expected.length, 5, 'hover event - special dates for assignment found');
      actual = $('tr.syllabus_assignment.related_event');
      deepEqual(actual.toArray(), expected.toArray(), 'hover event - special dates for assignment highlighted');
      override = $('tr.related-assignment_1.special_date:first');
      equal(override.length, 1, 'hover special date - found special date');
      override.simulate('mouseover');
      expected = $('tr.related-assignment_1').not(override);
      actual = $('tr.syllabus_assignment.related_event');
      equal(expected.length, 5, 'hover special date - related assignment and special dates found');
      deepEqual(actual.toArray(), expected.toArray(), 'hover special date - related assignment and special dates highlighted');
      override.simulate('mouseout');
      expected = [];
      actual = $('tr.syllabus_assignment.related_event');
      return deepEqual(actual.toArray(), expected, 'unhover event - events no longer highlighted');
    });
    test('hide/show special events', function() {
      var actual, day, expected, toggleSpecial;

      expect(20);
      this.view.is_public_course = true;
      this.view.can_participate = true;
      this.render();
      day = $('#mini_day_2012_01_31');
      equal(day.length, 1, 'render - expected day found');
      toggleSpecial = $('#toggle_special_dates_in_syllabus');
      equal(toggleSpecial.length, 1, 'render - toggle special dates found');
      equal(toggleSpecial.hasClass('shown'), true, 'render - toggle marked as shown');
      equal(toggleSpecial.hasClass('hidden'), false, 'render - toggle not marked as hidden');
      expected = $('tr.syllabus_assignment, tr.syllabus_event');
      actual = expected.filter(':visible');
      equal(expected.length, 16, 'render - all events found');
      deepEqual(actual.toArray(), expected.toArray(), 'render - all events visible');
      equal(day.hasClass('has_event'), true, 'render - dates with special events shown as having events');
      toggleSpecial.simulate('click');
      equal(toggleSpecial.hasClass('shown'), false, 'hide special - toggle not marked as shown');
      equal(toggleSpecial.hasClass('hidden'), true, 'hide special - toggle marked as hidden');
      expected = [];
      actual = $('tr.special_date:visible');
      deepEqual(actual.toArray(), expected, 'hide special - all special events hidden');
      expected = $('tr.syllabus_assignment:not(.special_date), tr.syllabus_event:not(.special_date)');
      actual = expected.filter(':visible');
      equal(expected.length, 11, 'hide special - all non-special events found');
      deepEqual(actual.toArray(), expected.toArray(), 'hide special - all non-special events visible');
      equal($('.mini_calendar_day.has_event').length, 4, 'hide special - dates that have non-special events still shown as having events');
      equal(day.hasClass('has_event'), false, 'hide special - dates with only special events no longer shown having events');
      toggleSpecial.simulate('click');
      equal(toggleSpecial.hasClass('shown'), true, 'show special - toggle marked as shown');
      equal(toggleSpecial.hasClass('hidden'), false, 'show special - toggle not marked as hidden');
      expected = $('tr.syllabus_assignment, tr.syllabus_event');
      actual = expected.filter(':visible');
      equal(expected.length, 16, 'show special - all events found');
      deepEqual(actual.toArray(), expected.toArray(), 'show special - all events once again visible');
      equal($('.mini_calendar_day.has_event').length, 5, 'show special - dates that have non-special events still shown as having events');
      return equal(day.hasClass('has_event'), true, 'show special - dates with only special events no longer shown having events');
    });
    return test('mini calendar', function() {
      var actual, eventMiniDay, expected, jumpToTodayLink, nextMonthLink, nonEventMiniDay, prevMonthLink;

      expect(27);
      this.view.is_public_course = true;
      this.view.can_participate = true;
      this.render();
      nonEventMiniDay = $('#mini_day_2012_01_17');
      equal(nonEventMiniDay.length, 1, 'non-event day hover - found');
      nonEventMiniDay.simulate('mouseover');
      deepEqual($('.mini_calendar_day.related').toArray(), nonEventMiniDay.toArray(), 'non-event day hover - highlighted');
      eventMiniDay = $('#mini_day_2012_01_30');
      equal(eventMiniDay.length, 1, 'event day hover - event day found');
      eventMiniDay.simulate('mouseover');
      deepEqual($('.mini_calendar_day.related').toArray(), eventMiniDay.toArray(), 'event day hover - event day highlighted');
      expected = $('.events_2012_01_30');
      actual = $('tr.date.related');
      equal(expected.length, 1, 'event day hover - syllabus event found');
      deepEqual(actual.toArray(), expected.toArray(), 'event day hover - syllabus event highlighted');
      eventMiniDay.simulate('mouseout');
      expected = [];
      actual = $('.mini_calendar_day.related');
      deepEqual(actual.toArray(), expected, 'event day unhover - mini calendar day no longer highlighted');
      expected = [];
      actual = $('tr.date.related');
      deepEqual(actual.toArray(), expected, 'event day unhover - syllabus events no longer highlighted');
      prevMonthLink = $('.prev_month_link');
      equal(prevMonthLink.length, 1, 'previous month - link found');
      prevMonthLink.simulate('mousedown');
      equal(parseInt($('.month_number').text()), 12, 'previous month - month changed to December');
      equal(parseInt($('.year_number').text()), 2011, 'previous month - year changed to 2011');
      expected = $('#mini_day_2012_01_01');
      actual = $('.mini_calendar_day.has_event');
      equal(expected.length, 1, 'previous month - expected dates with events found');
      deepEqual(actual.toArray(), expected.toArray(), 'previous month - expected dates with events highlighted');
      nextMonthLink = $('.next_month_link');
      equal(nextMonthLink.length, 1, 'next month - link found');
      nextMonthLink.simulate('mousedown');
      nextMonthLink.simulate('mousedown');
      equal(parseInt($('.month_number').text()), 2, 'next month - month changed to February');
      equal(parseInt($('.year_number').text()), 2012, 'next month - year changed to 2012');
      expected = $('#mini_day_2012_01_30, #mini_day_2012_01_31');
      actual = $('.mini_calendar_day.has_event');
      equal(expected.length, 2, 'next month - expected dates with events found');
      deepEqual(actual.toArray(), expected.toArray(), 'next month - expected dates with events highlighted');
      jumpToTodayLink = $('a.jump_to_today_link');
      equal(jumpToTodayLink.length, 1, 'jump to today - link found');
      jumpToTodayLink.simulate('click');
      equal(parseInt($('.month_number').text()), 1, 'jump to today - month changed to January');
      equal(parseInt($('.year_number').text()), 2012, 'jump to today - year left at 2012');
      expected = $('#mini_day_2012_01_01, #mini_day_2012_01_11, #mini_day_2012_01_23, #mini_day_2012_01_30, #mini_day_2012_01_31');
      actual = $('.mini_calendar_day.has_event');
      equal(expected.length, 5, 'jump to today - expected has event dates found');
      deepEqual(actual.toArray(), expected.toArray(), 'jump to today - expected dates with events highlighted');
      expected = $('#mini_day_2012_01_23');
      actual = $('.mini_calendar_day.selected');
      equal(expected.length, 1, 'jump to today - today found');
      deepEqual(actual.toArray(), expected.toArray(), 'jump to today - today highlighted');
      expected = $('.events_2012_01_23');
      actual = $('tr.date.selected');
      equal(expected.length, 1, 'jump to today - today\'s events found');
      return deepEqual(actual.toArray(), expected.toArray(), 'jump to today - today\'s events highlighted');
    });
  });

}).call(this);

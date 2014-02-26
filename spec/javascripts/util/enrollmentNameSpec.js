(function() {
  define(['compiled/util/enrollmentName'], function(enrollmentName) {
    module('enrollmentName');
    return test('it converts a role name to the name', function() {
      equal(enrollmentName('StudentEnrollment'), 'Student');
      equal(enrollmentName('TeacherEnrollment'), 'Teacher');
      equal(enrollmentName('TaEnrollment'), 'TA');
      equal(enrollmentName('ObserverEnrollment'), 'Observer');
      equal(enrollmentName('DesignerEnrollment'), 'Course Designer');
      return equal(enrollmentName('no match'), 'no match');
    });
  });

}).call(this);

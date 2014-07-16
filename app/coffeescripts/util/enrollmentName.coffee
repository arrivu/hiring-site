define ['i18n!enrollmentNames'], (I18n) ->

  types =
    StudentEnrollment:  I18n.t "student", "Candidate"
    TeacherEnrollment:  I18n.t "teacher", "Hiring Manager"
    TaEnrollment:       I18n.t "teacher_assistant", "Interviewer"
    ObserverEnrollment: I18n.t "observer", "HR"
    DesignerEnrollment: I18n.t "course_designer", "Project Designer"

  enrollmentName = (type) ->
    types[type] or type


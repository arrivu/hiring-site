define [
  'underscore'
  'Backbone'
  'jst/candidate_list/IndexView'
  'compiled/collections/CandidateCollection'
  'compiled/views/candidate_list/AddCandidatesView'
  'compiled/views/candidate_list/AddCandidatesItemView'
], (_, Backbone, template, CandidateCollection, AddCandidatesView, AddCandidatesItemView) ->

  class IndexView extends Backbone.View

    template: template
    events:
      'click #add_row' : "addRow"
      'click #delete_row' : "deleteRow"
      'click #select_all' : "checkAll"
      'click #add_candidates' : "addCandidates"
      'click #send_invitations' : "sendInvitations"

    sendInvitations:(event) ->
      alert("ok")
#      if document.getElementById("dataTable")?
#        table = document.getElementById("dataTable")
#        rows = table.getElementsByTagName("tr")
#        name = ""
#        email = ""
#        i = 1
#
#        while i < rows.length
#          rows[i].i = i
#          name = table.rows[i].cells[1].innerHTML
#          email = table.rows[i].cells[2].innerHTML
#          console.log "name: " + name + " email: " + email
#          i++
#      return
      table = document.getElementById("dataTable")
      i = 0
      row = undefined

      while row = table.rows[i]

        j = 0
        col = undefined

        while col = row.cells[j]
          console.log row[i].cells[j]
          j++
        i++

    addCandidates: (event) ->
      candidateCollection = new CandidateCollection
      candidateCollection.on 'sync', @renderAddCandidateItem,candidateCollection
      candidateCollection.url = "/api/v1/courses/#{ENV.COURSE_ID}/quizzes/#{ENV.QUIZZ_ID}/invitations"
      candidateCollection.fetch()
      addCandidatesView = new AddCandidatesView
        collection: candidateCollection
        el: '#render_popup'
      addCandidatesView.render()

    renderAddCandidateItem:(collection)  ->
       for model in collection.models
        candidate_name = model.attributes.user.name
        console.log(model.attributes.user.pseudonyms)
        for pseudonym in model.attributes.user.pseudonyms
          candidate_email = pseudonym.pseudonym.unique_id
          addCandidatesItemView = new AddCandidatesItemView
            name: candidate_name
            email: candidate_email
          $('#candidate_list').append(addCandidatesItemView.render().el)

    addRow: (event) ->
      table = document.getElementById("dataTable")
      rowCount = table.rows.length
      row = table.insertRow(rowCount)
      cell1 = row.insertCell(0)
      element1 = document.createElement("input")
      element1.type = "checkbox"
      element1.name = "chkbox[]"
      element1.checked = "checked"
      cell1.appendChild element1
      cell2 = row.insertCell(1)
      element3 = document.createElement("input")
      element3.type = "text"
      element3.name = "txtbox[]"
      element3.placeholder="Candidate Name"
      cell2.appendChild element3
      cell3 = row.insertCell(2)
      element2 = document.createElement("input")
      element2.type = "text"
      element2.name = "txtbox[]"
      element2.placeholder="Candidate Email"
      cell3.appendChild element2
      return

    deleteRow: (event) ->
      table = document.getElementById("dataTable")
      rowCount = table.rows.length
      i = 0

      while i < rowCount
        row = table.rows[i]
        chkbox = row.cells[0].childNodes[0]
        if null isnt chkbox and true is chkbox.checked
          table.deleteRow i
          rowCount--
          i--
        i++

    checkAll: (event) ->

      checkboxes = new Array()
      checkboxes = document.getElementsByName("chkbox[]")
      arrMarkMail = document.getElementsByName("chkbox[]")

      i = 0

      while i < arrMarkMail.length
        value=document.getElementById("selectall").checked
        alert(value)
        if value == true
          alert("Ok if")
          arrMarkMail[i].setAttribute "checked", true  if checkboxes[i].type is "checkbox"
        else
          alert("Ok else")
          arrMarkMail[i].setAttribute "checked",false  if checkboxes[i].type is "checkbox"
        i++


#      i = 0
#      if document.getElementById("selectall").checked
#        while i < checkboxes.length
#          checkboxes[i].setAttribute "checked", true  if checkboxes[i].type is "checkbox"
#          i++
#      else
#        alert("Ok")
#        while i < checkboxes.length
#          checkboxes[i].setAttribute "checked", false  if checkboxes[i].type is "checkbox"
#          i++

      return




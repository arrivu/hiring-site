define [
  'underscore'
  'Backbone'
  'jst/candidate_list/IndexView'
#  'jst/assignments/NoAssignmentsSearch'
], (_, Backbone, template) ->

  class IndexView extends Backbone.View

    template: template
    events:
      'click #addrow' : "addRow"
      'click #deleterow' : "deleteRow"
      'click #selectall' : "checkAll"

    addRow: (event) ->
      table = document.getElementById("dataTable")
      rowCount = table.rows.length
      row = table.insertRow(rowCount)
      cell1 = row.insertCell(0)
      element1 = document.createElement("input")
      element1.type = "checkbox"
      element1.name = "chkbox[]"
      cell1.appendChild element1
      cell2 = row.insertCell(1)
      element3 = document.createElement("input")
      element3.type = "text"
      element3.name = "txtbox[]"
      element3.placeholder="Candidate Name"
      cell2.appendChild element3
#      cell2 = row.insertCell(1)
#      cell2.innerHTML = rowCount + 1
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
      alert("Ok")

      checkboxes = new Array()
      checkboxes = document.getElementsByName("chkbox[]")
      arrMarkMail = document.getElementsByName("chkbox[]")
      i = 0

      while i < arrMarkMail.length
        arrMarkMail[i].checked = true
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
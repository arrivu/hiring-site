define [
  'jquery'
  'compiled/views/PaginatedCollectionView'
  'jst/candidate_list/AddCandidates'
  'compiled/views/candidate_list/AddCandidatesItemView'
  'compiled/jquery/fixDialogButtons'
], ($,PaginatedCollectionView, template, AddCandidatesItemView) ->

  class AddCandidatesView extends PaginatedCollectionView

    template: template
    className: 'candidate_list_items'
    itemView: AddCandidatesItemView

#    onCollectionSync: (collection) ->
#      for model in collection.models
#        candidate_name = model.attributes.user.name
#        console.log(model.attributes.user.pseudonyms)
#        for pseudonym in model.attributes.user.pseudonyms
#          candidate_email = pseudonym.pseudonym.unique_id
#          pseudonym_id = pseudonym.pseudonym.id
#          addCandidatesItemView = new AddCandidatesItemView
#            name: candidate_name
#            email: candidate_email
#            pseudonymId: pseudonym_id
#          $('.candidate_list_items').append(addCandidatesItemView.render().el)

    afterRender: ->
      super
      @$el.dialog
        title: 'Candidates selected to send invitations'
        width: 800
        height: "auto"
        resizable: true
        buttons: [
          class: "btn-success send_invitation_confirm"
          text:  'Confirm'
          'data-text-while-loading': 'Sending Invitations...'
          click: => @submit()
        ]
#        console.log(@collection)
#        @collection.on 'sync', @onCollectionSync,@collection

      @$el.submit (e) =>
        @submit()
        return false
      this

    submit: ->
      values = new Array()
      $.each $("input[name='chkbox[]']:checked").closest("td").siblings("td"), ->
        values.push $(this).text()
        return

      str = values.join(",")
      myarray = str.split(",")
      email_array = new Array()
      i = 0

      while i < myarray.length
        email_array.push myarray[i]  if (i % 2)!=0
        i++
      json = JSON.stringify(email_array)
      console.log(json)
      alert json
      @collection.fetch
        email: json
        type: "POST"
#      this.$el.parent().find('.btn-primary').removeClass('ui-state-hover')
      super



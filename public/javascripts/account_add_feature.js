require([
    'i18n!accounts' /* I18n.t */,
    'jquery' /* $ */,
    'user_sortable_name',
    'jquery.instructure_forms' /* formSubmit */,
    'jqueryui/dialog',
    'compiled/jquery/fixDialogButtons' /* fix dialog formatting */,
    'compiled/jquery.rails_flash_notifications'
], function(I18n, $) {

    $(".add_feature_link").click(function(event) {
        event.preventDefault();
        var $dialog = $("#add_feature_dialog"),
            $buttonPane;
        $dialog.dialog({
            title: ( "Feature Not Available"),
            width: 500
        }).fixDialogButtons();
        $buttonPane = $dialog.closest('.ui-dialog').find('.ui-dialog-buttonpane');
        $("#add_feature_form :text:visible:first").focus().select();
    });
    $("#add_feature_form").formSubmit({
        required: ['user[name]'],
        beforeSubmit: function(data) {
            $(this).find("button").attr('disabled', true)
                .filter(".submit_button").text(I18n.t('adding_user_message', "Adding User..."));
        },
        success: function(data) {
            $(this).find("button").attr('disabled', false)
                .filter(".submit_button").text(I18n.t('add_user_button', "Add User"));
            var message = '';
            if(data.message_sent) {
                message = I18n.t('user_added_message_sent_message', '*%{user}* successfully added! They should receive an email confirmation shortly.', {user: user.name, wrapper: link});
            } else {
                message = I18n.t('user_added_message', '*%{user}* successfully added!', {user: user.name, wrapper: link});
            }
            $.flashMessage(message);
            $("#add_feature_dialog").dialog('close');
        },
        error: function(data) {
            $(this).find("button").attr('disabled', false)
                .filter(".submit_button").text(I18n.t('user_add_failed_message', "Adding User Failed, please try again"));
        }
    });
    $("#add_user_dialog .cancel_button").click(function() {
        $("#add_feature_dialog").dialog('close');
    });
});


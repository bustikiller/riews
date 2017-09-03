// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function(){
    function setupBasePathHelperEvents(scope) {
        $(scope).find('select[name=available_routes]').change(function (e) {
            $(e.target).closest('.nested-fields').find('.base-path input').val($(e.target).val());
        });
    }

    $('#action_links .add_fields').click(function(e){
        setTimeout(function(){
            var newGroup = $(e.target).closest('#action_links').find('.nested-fields').last()
            setupBasePathHelperEvents(newGroup);
        }, 100);
    });
    setupBasePathHelperEvents(document);
});
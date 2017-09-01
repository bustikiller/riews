// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function(){
    $( ".sortable" ).sortable({
        axis: 'y',
        items: '.sortable-item',
        handle: '.sort-handler'
    });
});

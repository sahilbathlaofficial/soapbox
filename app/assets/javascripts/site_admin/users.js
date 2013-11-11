$(document).ready(function(){
  $('.moderator_add').click(function(){
    if($(this).prop('checked') === true)
      $('#make_moderators').val($('#make_moderators').val() + $(this).val() + " ")
    else
      $('#make_moderators').val($('#make_moderators').val().replace($(this).val() + " ",""))
  });
});
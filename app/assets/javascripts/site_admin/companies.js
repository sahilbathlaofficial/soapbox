$(document).ready(function(){
  $('.to_ban_add').click(function(){
    if($(this).prop('checked') === true)
      $('#to_ban').val($('#to_ban').val() + $(this).val() + " ")
    else
      $('#to_ban').val($('#to_ban').val().replace($(this).val() + " ",""))
  });
});
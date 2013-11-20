groupHandler = function() {
  $('#createGroupLink').click(function(e) {
    e.preventDefault();
    $('#createGroup').show();
    if($('#createGroupTextField').val().trim() != '')
      $('#createGroup').find('form').submit();
    $('#createGroupTextField').focus();
  });
  $('#cancelCreateGroup').on('click', function(e) {
    $('#createGroup').hide();
  });
}

$(document).ready(function() {
  groupHandler(); 
});
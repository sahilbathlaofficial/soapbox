groupHandler = function() {
  $('#createGroupLink').click(function(e) {
    e.preventDefault();
    $('#createGroup').show();
    $('#createGroupTextField').focus();
  });
  $('#cancelCreateGroup').on('click', function(e) {
    $('#createGroup').hide();
  });
}

$(document).ready(function() {
  groupHandler(); 
});
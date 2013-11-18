setModalMargin =  function() {
  $('#profilePicContainer').ready(function() {
    $modal = $('#profilePicContainer');
    div_height = $modal.height();

    $( "#profilePicContainer img" ).load(function() {
      content_height = $('#profilePicContainer img').height();
      margin_height = ((div_height - content_height)/2)
      $('#profilePicContainer img').css('margin-top', margin_height + 'px')   
      $('#profilePicContainer').addClass('hide'); 
    });
 
  });
}

$(document).ready(function() {
  setModalMargin();
});

changeOriginalButtonClass = function() {
  $('.btn-success, .btn-danger').width(75);
  $('.hovered-button').closest('form').hide();

  $('.buttonToggle').mouseenter(function(e){
    $(this).children().first().hide();
    $(this).children().last().show();
  }).mouseleave(function(e){
    $(this).children().first().show();
    $(this).children().last().hide();
  });

}

sideBarHeightHandler = function() {
  height = $('body').height() - 50;
  $('#left-sidebar, #right-sidebar').height(height); 
}


$(document).ready(function(){
  sideBarHeightHandler();
  changeOriginalButtonClass();
}); 
  
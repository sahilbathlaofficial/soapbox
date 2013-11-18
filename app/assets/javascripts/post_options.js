showPostOptionsOnClick = function() {
  $('.composePostContentOptions').hide();
  $('#composePost').click(function(e) {
    e.stopPropagation();
    $('.composePostContentOptions').show();
  });
  $('body').click(function() {
    $('.composePostContentOptions').hide();
  });
}

focusOnComments = function() {
  $('.postOptionsComment').click(function(e){
    e.preventDefault();
    $(this).closest('.postOptions').find('.commentText').focus();
  });
}

$(document).ready(function() {
  showPostOptionsOnClick();
  focusOnComments();
});

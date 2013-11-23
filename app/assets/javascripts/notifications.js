/* notifications */


notificationCheck = function() {
  window.setInterval(fetchNotification, 60 * 1000);
}

fetchNotification = function() {
  if($('#newNotificationMsg').length != 1)
  {
    $.getJSON("/x/notifications/get_new_notifications").done(function(data) {
      console.log(data);
      if(data.length != 0)
      {
        $('#notificationSprite').html('').append('<a class="appLinks" data-remote="true" href="/vinsol/notifications"><div id="notificationSpriteContent">Notifications</div></a>');
        $('#notificationSpriteContent').append('<div id="newNotificationMsg" class="generalContainer">You have new notifications!! </div>');
        blinkEvent = window.setInterval(function() {
          $('#notificationSprite').toggleClass('blink');
        }, 500)
        
        $('#notificationSprite').click(function(){
          window.clearInterval(blinkEvent);
          $('#notificationSprite').removeClass('blink');
        })
      }
    });
  }
}

$(document).ready(function(){
  notificationCheck();
});

/* end of notifications js */
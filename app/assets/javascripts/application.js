// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require jquery.turbolinks
//= require jquery.ui.all
//= require_tree .

users = []

notificationCheck = function() {
  window.setInterval(fetchNotification,1000);
}


fetchNotification = function() {
  if($('#newNotificationMsg').length != 1)
  {
    $.getJSON("/notifications/get_new_notifications").done(function(data) {
      console.log(data);
      if(data.length != 0)
      {
        $('.notificationSpriteContent').html('').append('<a class="appLinks" data-remote="true" href="/notifications/index">Notifications</a>');
        $('.notificationSpriteContent').append('<div id="newNotificationMsg" class="generalContainer">You have new notifications!! </div>');
      }
    });
  }
}

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
  $('#left-sidebar').height(height);
}

groupHandler = function(){
  $('#createGroupLink').click(function(e) {
    e.preventDefault();
    $('#createGroup').show();
  });
  $('#cancelCreateGroup').on('click', function(e) {
    $('#createGroup').hide();
  });
}

autoFetchUsers = function() {

  element = $('#fetchNames')
  $('#userAutoCompleteSearchResults').hide();

   $('#userAutoCompleteSearchResults').click(function(e){
    e.stopPropagation();
  });

  $('body').click(function(){
    $('#userAutoCompleteSearchResults').hide();
  });

  $('#fetchNames').bind('keyup focus', function(){
    if(element.val().trim() === '')
      $('#userAutoCompleteSearchResults').hide();
    else
    {
      $('#userAutoCompleteSearchResults').show();
      query = element.val() + '%';
      console.log(query)

      $.getJSON("/users/autocomplete", {query: query }).done(function(data){
        users = data;
        console.log(users);
        $('#userAutoCompleteSearchResults').html('');
        if(users.length === 0)
        {
          $('#userAutoCompleteSearchResults').append('<div>No results found</div>')
        }
        for(i = 0; i < users.length; i++)
        {
          splitted_users= users[i];
          /*
          splitted_users[0] = firstname
          splitted_users[1] = lastname
          splitted_users[2] = id
          splitted_users[3] = image_name
          */
          if(splitted_users[3] === null)
            image = '<img class="thumbnailImage" src="/assets/missing.png"></img>';
          else
            image = '<img class="thumbnailImage" src="/system/users/avatars/000/000/00'+ splitted_users[2] + '/original/' + splitted_users[3] + '"></img>'

          $('#userAutoCompleteSearchResults').append('<a class="userAutoCompleteSearchResults" href="/users/' + splitted_users[2] + '"></a>')
            .children('a:last').append('<div>' + splitted_users[0] + ' ' + splitted_users[1] + '</div><br>')
            .children('div:first').before(image);
        }
      });
    } 

  })

}

$(document).ready(function(){
  sideBarHeightHandler();
  groupHandler(); 
  changeOriginalButtonClass();
  autoFetchUsers();
  showPostOptionsOnClick();
  focusOnComments();
  notificationCheck();
}); 
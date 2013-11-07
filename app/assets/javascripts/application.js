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

search_terms = []

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

/* notifications */

notificationCheck = function() {
  window.setInterval(fetchNotification, 1000);
}

fetchNotification = function() {
  if($('#newNotificationMsg').length != 1)
  {
    $.getJSON("/notifications/get_new_notifications").done(function(data) {
      console.log(data);
      if(data.length != 0)
      {
        $('#notificationSpriteContent').html('').append('<a class="appLinks" data-remote="true" href="/notifications/index">Notifications</a>');
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

/* end of notifications js */

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
  $('#left-sidebar, #right-sidebar').height(height); 
}

groupHandler = function(){
  $('#createGroupLink').click(function(e) {
    e.preventDefault();
    $('#createGroup').show();
    $('#createGroupTextField').focus();
  });
  $('#cancelCreateGroup').on('click', function(e) {
    $('#createGroup').hide();
  });
}

autoFetchUsers = function() {

  element = $('#fetchNames')
  $('#userAutoCompleteSearchResults').hide();

    // Stop the click event from propagating
   $('#userAutoCompleteSearchResults').click(function(e){
    e.stopPropagation();
  });

   // Hide the search results
  $('body').click(function(){
    $('#userAutoCompleteSearchResults').hide();
  });

  $('#fetchNames').bind('keyup focus', function(){
    // Hide in case no input 
    if(element.val().trim() === '')
      $('#userAutoCompleteSearchResults').hide();
    else
    {
      $('#userAutoCompleteSearchResults').show();
      query = element.val() + '%';
      console.log(query)

      $.getJSON("/users/autocomplete", {query: query }).done(function(data){
        search_terms = data;
        console.log(search_terms);
        $('#userAutoCompleteSearchResults').html('');
        if(search_terms.length === 0)
        {
          $('#userAutoCompleteSearchResults').append('<div>No results found</div>')
        }
        for(i=0; search_terms.length; i++)
        {
          search_term = search_terms[i];
          display_result = search_term[1] + ' ' + search_term[2];
          /*
          search_term[0] = id
          search_term[1] = firstname
          search_term[2] = lastname
          search_term[3] = image_name
          */
          if(search_term.length === 2)
          {
            display_result = search_term[1];
            image = '<img alt="Ror" class="thumbnailImage" src="/assets/ror.png">'; 
          }
          else if(search_term[3] === null)
          {
           image = '<img class="thumbnailImage" src="/assets/missing.png"></img>';
          }
          else
            image = '<img class="thumbnailImage" src="/system/users/avatars/000/000/00'+ search_term[0] + '/original/' + search_term[3] + '"></img>'

          $('#userAutoCompleteSearchResults').append('<a class="userAutoCompleteSearchResults" href="/users/' + search_term[0] + '"></a>')
            .children('a:last').append('<div>' + display_result + '</div><br>')
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
  setModalMargin();
  

 // window.scrollback = {
 //  streams:["vinsol"],
 //  theme: 'light',
 //  ticker: true,
 // };
 
 // /***** don't edit below *****/
 // (function(d,s,h,e){e=d.createElement(s);e.async=1;
 // e.src=h+'/client.min.js';scrollback.host=h;
 // d.getElementsByTagName(s)[0].parentNode.appendChild(e);}
 // (document,'script',location.protocol+'//scrollback.io'));

// $('body').delegate('.scrollback-title-content','click',function(){
//   $('.scrollback-nick-guest').parent().children('div:first').remove()
//   $('.scrollback-text-wrap').css('left','0px');
  
// });
 
 
}); 
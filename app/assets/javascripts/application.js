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
//= require_tree .

changeOriginalButtonClass = function() {
  $('.btn-success, .btn-danger').width(75);
  $('.hovered-button').closest('form').hide();

  $('.original-button').closest('form').hover(function(){
    $(this).closest('form').hide();
    $('.hovered-button').closest('form').show();
  });

  $('.hovered-button').closest('form').bind('mouseleave', function(){
     $(this).closest('form').hide();
    $('.original-button').closest('form').show();
  });

}

sideBarHeightHandler = function() {
  height = $('body').height() - 50;
  $('#left-sidebar').height(height);
}

groupHandler = function(){
  $('#createGroupLink').click(function(e) {
    console.log('clicked');
    e.preventDefault();
    $('#createGroup').show();
  });
}

$(document).ready(function(){
  sideBarHeightHandler();
  groupHandler(); 
  changeOriginalButtonClass();
}); 
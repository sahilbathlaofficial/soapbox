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

$(document).ready(function(){
  sideBarHeightHandler();
  groupHandler(); 
  changeOriginalButtonClass();
}); 
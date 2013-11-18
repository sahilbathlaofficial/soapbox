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

// CR_Priyank: Avoid writing js in application.js instead create a separate js file and require them here
// [Fixed] - Separate Files Created for different functions
search_terms = []

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
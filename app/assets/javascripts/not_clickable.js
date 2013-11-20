$(document).ready(function(){
  $(document).on('click','.notClickable', function(e){
    alert('clicked');
    e.preventDefault();
  });
});
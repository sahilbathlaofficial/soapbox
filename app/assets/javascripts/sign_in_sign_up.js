//= require jquery

$.urlParam = function(name){
    var results = new RegExp('[\\?&amp;]' + name + '=([^&amp;#]*)').exec(window.location.href);
    if(results != null)
      return results[1] || 0;
    else
      return 0
}

$(document).ready(function() {
  $('#languageSelector option[value="' + $.urlParam('locale') + '"]').prop('selected', true);
  $('#languageSelector').on('change', function(){
    $(this).closest('form').submit();
  });

});
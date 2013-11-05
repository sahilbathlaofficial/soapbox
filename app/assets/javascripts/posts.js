$(document).ready(function(){

  checkUrlPresence = function(text)
  {

    // console.log(text);
    if($('#postPreview').length != 1 && $('#loadingPostPreview').length != 1 )
    {
      if(x = text.match(/((((ht|f)tps?:\/\/)?(www\.))|(((ht|f)tps?:\/\/)))[a-z0-9-\.]+\.[a-z]{2,4}\/?([^\s<>"\,\{\}\\|\\\^\[\]`]+)?\s/))
      { 
        $('.composePostContentOptions').prepend('<div id="loadingPostPreview" class="centerAlignText"><img src="/assets/loading.gif" class="mediumImage" /></div>');
        $.get("/posts/extract_url_content",{ url: x[0] }).done(function() { $('#loadingPostPreview').remove(); })
        .fail(function(){
         $('#loadingPostPreview').html("Parse Error");
         window.setTimeout(function() { $('#loadingPostPreview').remove() },1000)
       });
      }
    }

  }

  provideUserTagList = function(user_hint) {
    console.log(user_hint)
    $.get("/users/tag_list",{query: '%' + user_hint + '%'}).done(function(){
    });
  }

  extractUrlSynopsis = function() {
    $('#composePostContent').keyup(function(e){
      checkUrlPresence($(this).val())
    })
  }

  addUserTags = function(e) {
    $('#composePostContent').keyup(function(e){
      if(user_hint = $(this).val().match(/[^\w]@(.+)/) || (user_hint = $(this).val().match(/^@(.+)/)) )
      {  
        if(e.keyCode != 27)
          provideUserTagList(user_hint[1]);
      }
      else
      {
        $('#userTagList').remove();
      }
    })
  }

  extractUrlSynopsis();
  addUserTags();

});
$(document).ready(function(){

  setPostContentBox = function()
  {
    if($('composePostContent').length === 1)
    {
      $('#composePostContent').autosize();
      position_compose_post = $('#composePostContent').position();
      $('#composePostCopy').css('top',position_compose_post.top+12)
      .css('left', position_compose_post.left+6.5 ).width($('#composePostContent').width())
    }
  }
  
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
      // $('.tagBackground').remove();
      // position_compose_post = $('#composePostContent').position();
      // position_of_tag = ($('#composePostContent').val().length)*6;
      // $('<div class="tagBackground"></div>').css('top', position_compose_post.top+22)
      // .css('left', position_compose_post.left+7 ).width(position_of_tag)
      // .appendTo($('body'));

      text_input = $(this).val();
      previous_content = $('#composePostCopy').html();

      $('#composePostCopy').html('').html($('#composePostContent').val());

      if($('#postTags').length == 1 )
      {
        value = $('#postTags').attr('data-name').split('-')
        for(i = 0; i < value.length; i++)
        {
          $('#composePostCopy').html($('#composePostCopy').html().replace(value[i],'<span class="tagBackground">' + value[i] + '</span>'));
        }
      }
  
      if(user_hint = text_input.match(/[^\w]@(.+)/) || (user_hint = text_input.match(/^@(.+)/)) )
      {  
        if(e.keyCode != 27)
          provideUserTagList(user_hint[1]);
      }
      else
      {
        position_compose_post = $('#composePostContent').position();
        $('#userTagList').remove();
      }
    })
  }

  setPostContentBox();
  extractUrlSynopsis();
  addUserTags();

});
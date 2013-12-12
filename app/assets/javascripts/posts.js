// CR_Priyank: Indent your code
// [Fixed]: Indented my code

$(document).ready(function() {
  var regex_url = /((((ht|f)tps?:\/\/)?(www\.))|(((ht|f)tps?:\/\/)))[a-z0-9-\.]+\.[a-z]{2,4}\/?([^\s<>"\,\{\}\\|\\\^\[\]`]+)?\s/
  
  // Giving a position to the background div
  setPostContentBox = function() {
    if($('#composePostContent').length === 1)
    {
      $('#composePostContent').autosize();
      position_compose_post = $('#composePostContent').position();
      $('#composePostCopy').css('top',position_compose_post.top)
      .css('left', position_compose_post.left)
      .css('padding',$('#composePostContent').css('padding'))
      .width($('#composePostContent').width())
    }

    if($('.commentText').length >= 1)
    {
      $('.commentText').each(function() {
        $(this).autosize();
        $(this).prev('.composeTextCopy').css('top', $(this).top)
        .css('left', $(this).left)
        .css('padding', $(this).css('padding'))
        .width($(this).width())
        $(this).css('margin-top', -($(this).prev('div.composeTextCopy').height() + parseFloat($(this).prev('div.composeTextCopy').css('padding-top')) ))
      })
    }
  }

  provideUserTagList = function(user_hint, text_box_id) 
  {
    console.log(user_hint)
    $.get("/users/tag_list",{query: '%' + user_hint + '%', text_box_id: text_box_id}).done(function(){
    });
  }

  addUserTags = function(e) {
  
    $(document).on('keyup','#composePostContent, .commentText', function(e) {

      var text_box_id= $(this).attr('id');
      var text_input = $(this).val();

      $text_copy_field = $(this).prev('div.composeTextCopy');
      $text_copy_field.html('').html($(this).val());

      // add tags if any
      if($(this).siblings('.postTags').length == 1 )
      {
        value = $(this).siblings('.postTags').attr('data-name').split('-')
        for(i = 0; i < value.length; i++)
        {
          
          $text_copy_field.html($text_copy_field.html().replace(value[i],'<span class="tagBackground">' + value[i] + '</span>'));
        }
      }

      // check if tag is requested and provide tag list
      if(user_hint = text_input.match(/[^\w]@(.+)/) || (user_hint = text_input.match(/^@(.+)/)) )
      {  
        if(e.keyCode != 27)
          provideUserTagList(user_hint[1], text_box_id);
      }
      else
      {
        $('#userTagList').remove();
      }

      // maintaining overflow of commentbox(as they are relative :() 
      if($(this).hasClass('commentText'))
      {
        $(this).css('margin-top', -($(this).prev('div.composeTextCopy').height() + parseFloat($(this).prev('div.composeTextCopy').css('padding-top')) ))
        $(this).next('input').css('margin-top', -($(this).prev('div.composeTextCopy').height()))
      }

    })

    
    
  }

// url extraction code //

  checkUrlPresence = function(text)
  {

    // console.log(text);
    if($('#postPreview').length != 1 && $('#loadingPostPreview').length != 1 )
    {
      // CR_Priyank: take this regexp out to a js constant
      // [Fixed] - Moved out the constant
      if(url_match = text.match(regex_url))
      { 
        $('.composePostContentOptions').prepend('<div id="loadingPostPreview" class="centerAlignText"><img src="/assets/loading.gif" class="mediumImage" /></div>');
        $.get("/posts/extract_url_content",{ url: url_match[0] }).done(function() { $('#loadingPostPreview').remove(); })
        .fail(function(){
         $('#loadingPostPreview').html("Parse Error");
         window.setTimeout(function() { $('#loadingPostPreview').remove() },1000)
       });
      }
    }

  }

  extractUrlSynopsis = function() {
    $('#composePostContent').keyup(function(e) {
      checkUrlPresence($(this).val())
    })
  }

  // end of url extraction //
  
  setPostContentBox();
  extractUrlSynopsis();
  addUserTags();

});
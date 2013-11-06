$(document).ready(function(){
   // set position of post hidden div for tagging
  setPostContentBox = function()
  {
    if($('#composePostContent').length === 1)
    {
      $('#composePostContent').autosize();
      position_compose_post = $('#composePostContent').position();
      $('#composePostCopy').css('top',position_compose_post.top + 12)
      .css('left', position_compose_post.left+6.5 ).width($('#composePostContent').width())
    }

    if($('.commentText').length >= 1)
    {
      $('.commentText').each(function(){
        $(this).autosize();
        position_compose_comment = $(this).position();
        $(this).prev('.composeTextCopy').css('top',position_compose_comment.top - 64)
        .css('left', position_compose_comment.left + 5 ).width($(this).width())
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
  
  $('#composePostContent, .commentText').keyup(function(e){
    // $('.tagBackground').remove();
    // position_compose_post = $('#composePostContent').position();
    // position_of_tag = ($('#composePostContent').val().length)*6;
    // $('<div class="tagBackground"></div>').css('top', position_compose_post.top+22)
    // .css('left', position_compose_post.left+7 ).width(position_of_tag)
    // .appendTo($('body'));

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
  })
}

 


// url extraction code //


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

  extractUrlSynopsis = function() {
    $('#composePostContent').keyup(function(e){
      checkUrlPresence($(this).val())
    })
  }

  // end of url extraction //
  setPostContentBox();
  extractUrlSynopsis();
  addUserTags();

  // $('#composePostContent').focus(function() {
  //   $('.commentText').prev('.composeTextCopy').each(function() {
  //     $(this).css('top',$(this).position().top + 64)
  //   });
  // });

  // $('#composePostContent').blur(function() {
  //   $('.commentText').prev('.composeTextCopy').each(function() {
  //     $(this).css('top',$(this).position().top - 64)
  //   });
  // });

});
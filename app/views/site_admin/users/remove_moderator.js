$('#remove_moderator<%= @user.id.to_s%>').parent()
.append('<%= check_box_tag("moderator_add" + @user.id.to_s, @user.id, false,  class: "moderator_add") %>')
$('#remove_moderator<%= @user.id.to_s%>').remove()
$('.moderator_add').click(function(){
    if($(this).prop('checked') === true)
      $('#make_moderators').val($('#make_moderators').val() + $(this).val() + " ")
    else
      $('#make_moderators').val($('#make_moderators').val().replace($(this).val() + " ",""))
  });

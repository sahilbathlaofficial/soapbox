search_terms = []

autoFetchUsers = function() {

  query = ''

  element = $('#fetchNames')
  $('#userAutoCompleteSearchResults').hide();

    // Stop the click event from propagating
   $('#userAutoCompleteSearchResults').click(function(e){
    e.stopPropagation();
  });

   // Hide the search results
  $('body').click(function(){
    $('#userAutoCompleteSearchResults').hide();
  });

  $('#fetchNames').bind('keyup focus', function(){
    // Hide in case no input 
    if(element.val().trim() === '')
      $('#userAutoCompleteSearchResults').hide();
    else
    {
      $('#userAutoCompleteSearchResults').show();
      query = element.val() + '%';
      console.log(query)

      $.getJSON("/users/autocomplete", {query: query }).done(function(data){
        search_terms = data;
        console.log(search_terms);
        $('#userAutoCompleteSearchResults').html('');
        try{
          for( i = 0; search_terms.length; i++)
          {
            search_term = search_terms[i];
            display_result = search_term[1] + ' ' + search_term[2];
            /*
            search_term[0] = id
            search_term[1] = firstname
            search_term[2] = lastname
            search_term[3] = image_name
            */
            if(search_term.length === 2)
            {
              display_result = search_term[1];
              image = '<img alt="Ror" class="thumbnailImage" src="/assets/ror.png">'; 
            }
            else if(search_term[3] === null)
            {
             image = '<img class="thumbnailImage" src="/assets/missing.png"></img>';
            }
            else
            {
              image = '<img class="thumbnailImage" src="/system/users/avatars/000/000/00'+ search_term[0] + '/original/' + search_term[3] + '"></img>'
            }

            $('#userAutoCompleteSearchResults').append('<a class="userAutoCompleteSearchResults" href="/users/' + search_term[0] + '"></a>')
              .children('a:last').append('<div>' + display_result + '</div><br>')
              .children('div:first').before(image);
          }
        }
        catch(err)
        {
        }
        $('#userAutoCompleteSearchResults').append('<a href="' + $("#userAutoCompleteSearch").attr("data-searchConversation") + '?query=' +  query.replace('%','') + '" class="blackButBlueOnHover"><div>Search conversation for "' + query.replace('%','') + '"</div></a>' )
      });
    } 

  })

}

$(document).ready(function(){
  autoFetchUsers();
});
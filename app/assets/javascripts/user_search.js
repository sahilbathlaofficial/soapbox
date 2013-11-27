search_terms = []

autoFetchUsers = function() {

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

      $.getJSON("/x/users/autocomplete", {query: query }).done(function(data){
        search_terms = data;
        console.log(search_terms);
        $('#userAutoCompleteSearchResults').html('');
        if(search_terms.length === 0)
        {
          $('#userAutoCompleteSearchResults').append('<div>No results found</div>')
        }
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
            image = '<img class="thumbnailImage" src="/system/users/avatars/000/000/00'+ search_term[0] + '/original/' + search_term[3] + '"></img>'

          $('#userAutoCompleteSearchResults').append('<a class="userAutoCompleteSearchResults" href="/company/users/' + search_term[0] + '"></a>')
            .children('a:last').append('<div>' + display_result + '</div><br>')
            .children('div:first').before(image);
        }
      });
    } 

  })

}

$(document).ready(function(){
  autoFetchUsers();
});
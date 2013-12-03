$apiTokenBox = $('#apiToken')
$apiTokenBox.html('')
$apiTokenBox.append('<p>Consumer Token: <%= current_user.consumer_key %></p>')
$apiTokenBox.append('<p>Consumer Secret: <%= current_user.consumer_secret %></p>')
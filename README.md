soapbox
=======

This app is social engine for companies, where users from same company can interact with other users od the same company. Also check out the api for using this application here :- <a href="https://github.com/sahilbathlavinsol/soapbox_api">Soapbox Api</a>

## Pre-Requisites

- You need to have mysql running on your machine and the mysql adapter for rails
- Install sphinx for conversation search feature. Here is a tutorial to install sphink :- <a href="http://pat.github.io/thinking-sphinx/installing_sphinx.html">Installing Sphinx</a>

## Installation

- Fork this repository
- Run bundle install
- Run rake db:create ( MySql required to be installed on your system )
- Run rake db:migrate

## Optional Rake Tasks

- Run users:admin to make any normal user of this website an admin
- Run rake jobs:work for delayed jobs (After running the server) - IF you want to use the mailing feature
- Run rake ts:index ( To index the search from conversation content )
- Run rake ts:start ( To start the searchd daemon )

## Features

- A user can create groups
- A user can share a post with whole company or a prticular group
- A user can search other users and groups from the same company
- A post can have hash-tags, user-tags and a user can share link
- A post also has features to like it and to comment on it
- Admin of this website can ban companies, groups and users
- Admin can also make other users moderators who can do the same as highlighted above

## Reporting issues
- If you face any issue, report me at sahil@visnol.com

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

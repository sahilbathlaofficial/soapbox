module TwitterConcern

  extend ActiveSupport::Concern
  
  def do_tweet
    # CR_Priyank: This can be moved to twitter API module which can be included in use model.
    # [Fixed] - added Twitter Concern
    if(current_user.twitter_authorize_token.present?)

      access_token = current_user.twitter_authorize_token.split # assuming @user
      client = TwitterOAuth::Client.new(
        # CR_Priyank: Move these keys to a constant and then use
        :consumer_key => 'CRCKDPmqhidBGtMbBliD8Q',
        :consumer_secret => '9l4NlQaZTIKijnNHGFZskkr79aesVEY1IKAV8vOIOE',
        :token => access_token[0],
        :secret => access_token[1]
      )

      client.update(self.content)
    end
  end

  def twitter_auth
    client = TwitterOAuth::Client.new(
      :consumer_key => 'CRCKDPmqhidBGtMbBliD8Q',
      :consumer_secret => '9l4NlQaZTIKijnNHGFZskkr79aesVEY1IKAV8vOIOE'
      )
    if(params[:oauth_verifier])
      request_token = session[:request_token]
      access_token = client.authorize(
        request_token.token,
        request_token.secret,
        :oauth_verifier => params[:oauth_verifier]
      )
      user = current_user
      user.twitter_authorize_token = access_token.token + " " + access_token.secret
      user.save!
      redirect_to edit_user_path(current_user)
    else
      request_token = client.request_token(:oauth_callback => twitter_auth_users_url )
      #:oauth_callback required for web apps, since oauth gem by default force PIN-based flow
      #( see http://groups.google.com/group/twitter-development-talk/browse_thread/thread/472500cfe9e7cdb9/848f834227d3e64d 

      session[:request_token] = request_token
      redirect_to request_token.authorize_url
      # http://twitter.com/oauth/authorize?oauth_token=TOKEN
    end
  end

end
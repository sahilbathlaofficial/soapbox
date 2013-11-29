class ApiController < ApplicationController
  respond_to  :xml, :json

  skip_before_action :authorize

  def fetch_posts
    # CR_Priyank: Should be moved to a before_action and user not present condition should be handled there.
    @user = User.find_by(consumer_key: params[:consumer_key], consumer_secret: params[:consumer_secret])
    if(@user.present?)
      respond_with(@user.posts)
    else
      respond_with({})
    end
  end
end

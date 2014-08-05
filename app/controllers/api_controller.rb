class ApiController < ApplicationController
  respond_to  :xml, :json

  skip_before_action :authorize
  before_action :authorize_accesss, only: :fetch_posts
  #3

  def fetch_posts
    # CR_Priyank: Should be moved to a before_action and user not present condition should be handled there.
    # [Fixed] - Moved to before action
    respond_with(@user.posts)
  end

  private

  def authorize_acess
    @user = User.find_by(consumer_key: params[:consumer_key], consumer_secret: params[:consumer_secret])
    respond_with({}) unless (@user)
  end
end

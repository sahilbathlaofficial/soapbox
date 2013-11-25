class ApiController < ApplicationController
  respond_to  :xml, :json

  skip_before_action :authorize

  def authorized?
    params[:consumer_key] == '123' && params[:consumer_secret] == 'xyz'
  end

  def fetch_posts
    if(authorized?)
      respond_with(User.first.posts) 
    else
      respond_with(params)
    end
  end
end

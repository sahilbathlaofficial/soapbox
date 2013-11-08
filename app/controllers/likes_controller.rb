class LikesController < ApplicationController
  before_action :set_likes, only: [:destroy]

  def create
    @like = Like.new(like_params)
    respond_to do |format|
      if(@like.save)  
        format.js {}
      else
        format.js { flash[:notice] = 'Like not saved'}
      end
    end
  end

  def destroy
    if(@like.destroy)
      respond_to do |format|
        format.js {}
      end
    end
  end

  protected

  def set_likes
    @like = Like.find_by(user_id: params[:user_id], post_id: params[:post_id])
    redirect_to_back_or_default_url if(@like.nil?)
  end

  def like_params
    begin
      User.find_by(id: params[:user_id])
      Post.find_by(id: params[:post_id])
    end
    params.permit(:user_id, :post_id)
  end

end

class LikesController < ApplicationController
  before_action :set_likes, only: [:destroy]

  def create
    @like = Like.new(like_params)
    if(@like.save)
      respond_to do |format|
        format.js {}
      end
    end
  end

  def destroy
    if(@like[0].destroy)
      respond_to do |format|
        format.js {}
      end
    end
  end

  protected

  def set_likes
    @like = Like.where("user_id=? and post_id=?", params[:user_id], params[:post_id])
  end

  def like_params
    params.permit(:user_id, :post_id)
  end
end

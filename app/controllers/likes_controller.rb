class LikesController < ApplicationController
  before_action :set_post
  before_action :set_likes, only: [:destroy]

  def create
    # CR_Priyank: I think this should be like current_user.likes.build(like_params)
    # [Fixed] - Using build but with respect to post not user
    @like = @post.likes.build(like_params)
    respond_to do |format|
      if(@like.save)  
        format.js {}
      else
        # CR_Priyank: I think we shall use flash.now[:notice]
        # [Fixed] - Fixed
        format.js { flash.now[:notice] = 'Like not saved'}
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
    # CR_Priyank: this can also be written as redirect_to_back_or_default_url if(@like = Like.find_by(user_id: params[:user_id], post_id: params[:post_id]))
    # [Fixed]
    # CR_Priyank: Use current_user scope on likes
    # [Fixed] - Using post scope
    return false if !( @like = @post.likes.find_by(user_id: params[:user_id], post_id: params[:post_id]) )
  end

  def set_post
    @post = Post.find_by(id: params[:post_id]) 
    return false if !(@post.nil?)
  end

  def like_params
    # CR_Priyank: I am not sure why we are finding user and post here
    # [Fixed] - Removed 
    params.permit(:user_id, :post_id)
  end

end

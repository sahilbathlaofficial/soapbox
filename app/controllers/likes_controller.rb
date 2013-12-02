class LikesController < ApplicationController
  before_action :set_post
  before_action :set_likes, only: [:destroy]

  def create
    @like = @post.likes.build(like_params)
    respond_to do |format|
      if(@like.save)  
        format.js {}
      else
        # CR_Priyank: I think we shall use flash.now[:notice]
        # [Fixed] - Fixed
        format.js { flash.now[:error] = 'Like not saved'}
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
    # CR_Priyank: What are we trying by returning false
    # [Discuss - 2]
    return false if !( @like = @post.likes.find_by(user_id: params[:user_id], post_id: params[:post_id]) )
  end

  def set_post
    # CR_Priyank: This should be under user's scope
    # [Fixed] - Added user's scope
    @post = current_user.post.find_by(id: params[:post_id]) 
    # CR_Priyank: What are we trying by returning false
    # [Discuss - 2]
    return false if !(@post.nil?)
  end

  def like_params
    params.permit(:user_id, :post_id)
  end

end

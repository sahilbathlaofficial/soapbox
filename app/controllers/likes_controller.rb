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
    # [Fixed]
    unless ( @like = @post.likes.find_by(user_id: params[:user_id], post_id: params[:post_id]) )
      flash.now[:alert] = "some error occured"
      render action: params[:action]
    end
  end

  def set_post
    # CR_Priyank: This should be under user's scope
    # [Discuss - 11]
    @post = Post.find_by(id: params[:post_id]) 
    # CR_Priyank: What are we trying by returning false
    # [Fixed]
    unless (@post)
      flash.now[:alert] = "some error occured"
      render action: params[:action]
    end
  end

  def like_params
    params.permit(:user_id, :post_id)
  end

end

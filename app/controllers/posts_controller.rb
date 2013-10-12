class PostsController < ApplicationController

  def create
    @post = Post.new(post_params)
    current_user.posts << @post
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  protected

  def post_params
    params.require(:post).permit(:content, :group_id)
  end

end

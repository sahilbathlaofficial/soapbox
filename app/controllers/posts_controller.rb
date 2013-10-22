class PostsController < ApplicationController

  before_action :set_post, only: :destroy

  def create
    @post = Post.new(post_params)
    current_user.posts << @post
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def destroy
    if @post.user == current_user
      if @post.destroy
        redirect_to :back
      end
    end
  end

  protected

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :group_id).merge({ company_id: session[:company] })
  end

end

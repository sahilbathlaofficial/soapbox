class CommentsController < ApplicationController
  before_action :set_comments, only: [:destroy]

  def create
    @comment = Comment.new(comment_params)
    if(@comment.save)
      respond_to do |format|
        format.html { redirect_to :back }
      end
    end
  end

  def destroy
    if(@comment.destroy)
      respond_to do |format|
        format.html { redirect_to :back }
      end
    end
  end

  protected

  def set_comments
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.permit(:post_id, :content).merge( { user_id: current_user.id } )
  end
end

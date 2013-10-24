class CommentsController < ApplicationController
  before_action :set_comments, only: [:destroy]

  def create
    #FIXME_AB: You are relying on th post_id passed in the params. This could be a issue. Find the post with that id and make sure that post exists. Then do post.comments.build
    @comment = Comment.new(comment_params)
    #FIXME_AB: What is comment is not saved due to some reason
    if(@comment.save)
      respond_to do |format|
        #FIXME_AB: Don't use redirect_to :back. Instead you should make a helper method redirect_to_back_or_default. Which will check if HTTP_REFERER is present then will do the redirect_to :back else will redirect to the url passed to this funciton. Default will be root_path
        format.html { redirect_to :back }
      end
    end
  end

  def destroy
    #FIXME_AB: @comment.owner?(current_user)
    if(@comment.user == current_user)
      #FIXME_AB: What if it was not destoyed. I think you can make use of destroyed?
      if(@comment.destroy)
        respond_to do |format|
          format.html { redirect_to :back }
        end
      end
    end
  end

  protected

  def set_comments
    #FIXME_AB: What if the comment is not found with this id?
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.permit(:post_id, :content).merge( { user_id: current_user.id } )
  end
end

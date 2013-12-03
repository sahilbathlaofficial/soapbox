class CommentsController < ApplicationController
  include NotificationConcern

  before_action :set_comments, only: [:destroy]
  before_action :set_posts, only: [:create]

  # CR_Priyank: I think we can move comments create to posts controller using nested attributes
  #[To do]
  def create
    #FIXME_AB: You are relying on the post_id passed in the params. This could be a issue. Find the post with that id and make sure that post exists. Then do post.comments.build
    # [Fixed] Done so
    # CR_Priyank: This should be moved to a before_action and not found condition can be handled there
    # [Fixed] - Moved to before action
    @post.comments.build(comment_params)
    #FIXME_AB: What is comment is not saved due to some reason
    #[Fixed] - else case added
    if(@post.save)
      respond_to do |format|
        #FIXME_AB: Don't use redirect_to :back. Instead you should make a helper method redirect_to_back_or_default. Which will check if HTTP_REFERER is present then will do the redirect_to :back else will redirect to the url passed to this funciton. Default will be root_path
        #[Fixed] - Added a function for same in application controller
        format.html { redirect_to_back_or_default_url }
      end
    else
      respond_to do |format|
        format.html do 
          redirect_to_back_or_default_url
          flash[:error] = "Comment wasn't added due to some reason"
         end
      end
    end
  end

  def destroy
    #FIXME_AB: @comment.owner?(current_user)
    #[Fixed] - Added the function
    # CR_Priyank: I think user_provoleged restriction should be moved in model as validation
    #[Fixed] - Moved to user model
    # CR_Priyank: Not fixed
    # [Fixed]
      #FIXME_AB: What if it was not destoyed. I think you can make use of destroyed?
      #[Fixed] - used an else case instead    
    if(@comment.destroy)
      respond_to do |format|
        format.html { redirect_to_back_or_default_url }
      end
    else
      respond_to do |format|
        format.html do 
          flash[:error] = "Comment wasn't deleted due to some reason"
          redirect_to_back_or_default_url
        end
      end
    end

  end

  protected

  def set_comments
    #FIXME_AB: What if the comment is not found with this id?
    #[Fixed] - checked comment nil case
    # CR_Priyank: Indent properly
    # [Fixed]: Sorry sir
    @comment = Comment.find_by(id: params[:id])
    if(@comment.blank?)
      flash[:alert] = "Comment not found"
      redirect_to_back_or_default_url 
    end
  end

  def set_posts
    @post = Post.find_by(id: params[:post_id])
    if (@post.blank?)
      flash[:alert] = "Post not found to comment on "
      redirect_to_back_or_default 
    end
  end

  def comment_params
    params.permit(:content, :tags).merge( { user_id: current_user.id } )
  end
end
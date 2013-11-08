class CommentsController < ApplicationController
  include NotificationConcern

  before_action :set_comments, only: [:destroy]

  def create
    #FIXME_AB: You are relying on th post_id passed in the params. This could be a issue. Find the post with that id and make sure that post exists. Then do post.comments.build
    @post = Post.find_by(id: params[:post_id])
    if(@post.nil?)  
      redirect_to_back_or_default_url
      flash[:notice] = "Post not found"
      return false
    end
    @post.comments.build(comment_params)
    #FIXME_AB: What is comment is not saved due to some reason
    #[Fixed]
    if(@post.save)
      respond_to do |format|
        #FIXME_AB: Don't use redirect_to :back. Instead you should make a helper method redirect_to_back_or_default. Which will check if HTTP_REFERER is present then will do the redirect_to :back else will redirect to the url passed to this funciton. Default will be root_path
        #[Fixed]
        
        add_notifications(@post)

        format.html { redirect_to_back_or_default_url }
      end
    else
      respond_to do |format|
        format.html do 
          redirect_to_back_or_default_url
          flash[:notice] = "Comment wasn't added due to some reason"
         end
      end
    end
  end

  def destroy
    #FIXME_AB: @comment.owner?(current_user)
    #[Fixed]
    if(@comment.owner?current_user)
      #FIXME_AB: What if it was not destoyed. I think you can make use of destroyed?
      #[Fixed]     
      if(@comment.destroy)
        respond_to do |format|
          format.html { redirect_to_back_or_default_url }
        end
      else
        respond_to do |format|
          format.html do 
            redirect_to_back_or_default_url
            flash[:notice] = "Comment wasn't deleted due to some reason"
          end
        end
      end
    else
      flash[:notice] = "You can't delete this comment"
      redirect_to_back_or_default_url
    end

  end

  protected

  def set_comments
    #FIXME_AB: What if the comment is not found with this id?
    #[Fixed]
      @comment = Comment.find_by(id: params[:id])
      redirect_to_back_or_default_url if(@comment.nil?)
  end

  def comment_params
    params.permit(:content, :tags).merge( { user_id: current_user.id } )
  end

  def add_notifications(post)
    @post = post
    @post.comments.last.create_activity key: 'comment.create', owner: @post.user
      SoapBoxMailer.comment_email(@post.user, current_user, @post).deliver
      if !(@post.comments.last.tags.nil?)
        notify_tagged_users(@post.comments.last.tags, @post)
      end
    end
end
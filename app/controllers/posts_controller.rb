class PostsController < ApplicationController
  # CR_Priyank: Why are we expiring fragment on all actions
  # [Fixed]: OOps sorry, only required in create and destroy
  before_action only: [:create, :destroy] { |post| post.expire_fragment('my_posts' + current_user.name) }
  before_action :set_post, only: [:destroy, :show]
  before_action :parse_url, only: [:extract_url_content]

  def create
    @post = current_user.posts.build(post_params)  
    @post.url_parsed_content = URLParsedContent.new(set_parsed_content)  if (params[:post][:extra_content].present?)
    # CR_Priyank: I think "current_user.posts << @post" is not required. We can do @post.create
    # [Fixed] - Using @post.save
    if(@post.save)
      respond_to do |format|
        format.html do 
          flash[:notice] = "Your post was succesful"
          redirect_to_back_or_default_url 
        end
      end
    else
      respond_to do |format|
        format.html do 
          flash[:error] = "Your post failed"
          redirect_to_back_or_default_url 
        end
      end
    end
  end

  def destroy
    # CR_Priyank: This must be moved to model validation
    # [Fixed]
    if @post.destroy
      flash[:notice] = "Post destroyed"
    else
      flash[:error] = "Post not destroyed"
    end
    redirect_to_back_or_default_url
  end

  def show
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def search
    @search_results = ThinkingSphinx.search (params[:query]  || '') + ' ' + current_user.name
  end

  def hash_tags
    # CR_Priyank: Move this query to model scope
    # [Fixed] - Moved 
    @posts = Post.find_by_hash_tag(params[:hash_tag], current_company.users)
  end

  def extract_url_content
    begin
      @doc = Nokogiri::HTML(open(@url))
      respond_to do |format|
        format.js {}
      end
    rescue
      @url = @url.sub('http://', 'https://')
      @doc = Nokogiri::HTML(open(@url))
      respond_to do |format|
        format.js {}
      end
    end
    
  end

  protected


  def set_post
    @post = Post.find_by(id: params[:id])
    if(@post.nil?)
      flash[:alert] = "Post not found"
      redirect_to_back_or_default_url 
    end
  end

  def set_parsed_content
    params[:post][:extra_content].permit!
  end

  def post_params
    params.require(:post).permit(:content, :group_id, :tags)
  end

  def parse_url
    @url = params[:url][0..-2] #remove the space
    @url = 'http://' + @url if(@url[0..3].downcase == 'www.')
  end

end

class PostsController < ApplicationController

  before_action :set_post, only: [:destroy, :show]
  before_action :parse_url, only: [:extract_url_content]

  def create
    # CR_Priyank: We can use current_user.posts.build(post_params)
    # [Fixed] - Using so
    @post = current_user.posts.build(post_params)  
    # CR_Priyank: We can also use params[:post][:extra_content].present?
    # [Fixed] - Done
    @post.url_parsed_content = URLParsedContent.new(set_parsed_content)  if (params[:post][:extra_content].present?)
    current_user.posts << @post
    # CR_Priyank: This must be moved to model
    # [Fixed] - Moved to Post model
    # CR_Priyank: We can also use @post.tags.present?
    # [Fixed] - using present
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def destroy
    if current_user.privileged?(@post)
      if @post.destroy
        redirect_to :back
      end
    end
  end

  def show
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def extract_url_content
    # CR_Priyank: move parsing logic to before_filter
    # [Fixed]
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
    redirect_to_back_or_default_url if(@post.nil?)
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

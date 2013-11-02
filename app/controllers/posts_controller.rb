class PostsController < ApplicationController

  before_action :set_post, only: :destroy

  def create
    @post = Post.new(post_params)  
    @post.url_parsed_content = URLParsedContent.new(set_parsed_content)  if !(params[:post][:extra_content].nil?)
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

  def extract_url_content
    @url = params[:url][0..-2] #remove the space
    @url = 'http://' + @url if(@url[0..3].downcase == 'www.')
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
    @post = Post.find(params[:id])
  end
  def set_parsed_content
   params[:post][:extra_content].permit!
  end

  def post_params
    params.require(:post).permit(:content, :group_id).merge({ company_id: current_company.id })
  end

end

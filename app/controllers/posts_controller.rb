class PostsController < ApplicationController
  # CR_Priyank: Why are we expiring fragment on all actions
  before_action { |post| post.expire_fragment('my_posts') }
  before_action :set_post, only: [:destroy, :show]
  before_action :parse_url, only: [:extract_url_content]

  def create
    @post = current_user.posts.build(post_params)  
    @post.url_parsed_content = URLParsedContent.new(set_parsed_content)  if (params[:post][:extra_content].present?)
    # CR_Priyank: I think "current_user.posts << @post" is not required. We can do @post.create
    current_user.posts << @post
    do_tweet(@post.content)
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def destroy
    # CR_Priyank: This must be moved to model validation
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

  def search
    @search_results = ThinkingSphinx.search (params[:query]  || '') + ' ' + current_user.name
  end

  def hash_tags
    # CR_Priyank: Move this query to model scope
    @posts = Post.where('content like ? and user_id in (?)', '%' + params[:hash_tag] + '%', current_company.users)
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

  def do_tweet(tweet)
    # CR_Priyank: This can be moved to twitter API module which can be included in use model. (Discuss)
    if(current_user.twitter_authorize_token.present?)

      access_token = current_user.twitter_authorize_token.split # assuming @user
      client = TwitterOAuth::Client.new(
        # CR_Priyank: Move these keys to a constant and then use
        :consumer_key => 'CRCKDPmqhidBGtMbBliD8Q',
        :consumer_secret => '9l4NlQaZTIKijnNHGFZskkr79aesVEY1IKAV8vOIOE',
        :token => access_token[0],
        :secret => access_token[1]
      )

      client.update(tweet)
    end

  end

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

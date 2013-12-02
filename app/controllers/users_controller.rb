class UsersController < ApplicationController

  before_filter :set_user, :except => [:autocomplete, :tag_list, :wall, :twitter_auth]

  def show
    if(current_user.company_id != @user.company_id)
      flash[:alert] = 'User doesn\'t exist'
      redirect_to root_path
    end
  end


  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User #{@user.firstname} was successfully updated." }
      else
        format.html { render action: 'edit', error: "Profile not updated" }
      end

    end
  end

  def destroy
    # CR_Priyank: Move this to validation
    # [Fixed]
    if(@user.destroy)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'User destroyed' }
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, error: 'User not destroyed' }
      end
    end
  end

  def wall
    users = current_user.followees + [current_user]
    groups = current_user.groups
    @posts = Post.extract_posts(users, groups)
  end

  def followees
    @followees = @user.followees
  end

  def followers
    @followers = @user.followers
  end

  def autocomplete
    # CR_Priyank: Move query in model scope
    # [Fixed] - Moved to scope
    @users = current_company.users.match_users(params[:query].downcase, current_user.company_id)
    @users += current_company.groups.match_groups(params[:query].downcase, current_user.company_id)
    respond_to do |format|
      format.json { render json: @users }
    end
  end

  def tag_list
    users = current_user.followers + current_user.followees + [current_user] 
    @users = current_company.users.where('(CONCAT(LOWER(firstname), " ", LOWER(lastname)) like ?) AND id in (?)',  params[:query].downcase, users).limit(5)
    respond_to do |format|
      format.js {}
    end
  end

  def twitter_auth
    client = TwitterOAuth::Client.new(
      :consumer_key => 'CRCKDPmqhidBGtMbBliD8Q',
      :consumer_secret => '9l4NlQaZTIKijnNHGFZskkr79aesVEY1IKAV8vOIOE'
      )
    if(params[:oauth_verifier])
      request_token = session[:request_token]
      access_token = client.authorize(
        request_token.token,
        request_token.secret,
        :oauth_verifier => params[:oauth_verifier]
      )
      user = current_user
      user.twitter_authorize_token = access_token.token + " " + access_token.secret
      user.save!
      redirect_to edit_user_path(current_user)
    else
      request_token = client.request_token(:oauth_callback => twitter_auth_users_url )
      #:oauth_callback required for web apps, since oauth gem by default force PIN-based flow
      #( see http://groups.google.com/group/twitter-development-talk/browse_thread/thread/472500cfe9e7cdb9/848f834227d3e64d 

      session[:request_token] = request_token
      redirect_to request_token.authorize_url
      # http://twitter.com/oauth/authorize?oauth_token=TOKEN
    end
  end

  def api_token
    current_user.set_api_token
    respond_to do |format|
      format.js {}
    end
  end

  protected


  def set_user
    # CR_Priyank: Indent properly
    # [Fixed] Sorry sir
    @user = User.find_by(id: params[:id])
    redirect_to_back_or_default_url if(@user.nil?)
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :avatar)
  end


end
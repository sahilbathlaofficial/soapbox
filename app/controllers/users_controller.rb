class UsersController < ApplicationController

  include TwitterConcern
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
    @users = current_company.users.extract_tags(params[:query].downcase, users)
    respond_to do |format|
      format.js {}
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
    redirect_to_back_or_default_url if(@user.blank?)
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :avatar)
  end


end
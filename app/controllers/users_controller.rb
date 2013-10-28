class UsersController < ApplicationController

  before_filter :set_user, :only => [:edit,  :update, :show, :wall, :show_followees, :show_followers]

  def show
    if(current_user.company_id != @user.company_id)
      redirect_to '/'
    end
  end


  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User #{@user.firstname} was successfully updated." }
      else
        format.html { render action: 'edit' }
      end

    end
  end

  def wall
    users = current_user.followees + [current_user]
    groups = current_user.groups 
    @posts = Post.where('user_id in (?) or group_id in (?) or group_id is ?', users, groups, nil).order('created_at DESC')
  end

  def show_followees
    @followees = @user.followees
  end

  def show_followers
    @followers = @user.followers
  end

  def autocomplete
    @users = User.where('(LOWER(firstname) like ? OR LOWER(lastname) like ?) AND company_id = ? ', params[:query].downcase, params[:query].downcase, current_user.company_id).limit(5).pluck('firstname','lastname', 'id', 'avatar_file_name')
    respond_to do |format|
      format.json { render json: @users }
    end
  end

  protected


  def set_user
    if(params[:id])
      @user = User.find(params[:id])
    else
      redirect_to(wall_user_path(current_user))
    end
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :avatar)
  end


end

class UsersController < ApplicationController

  before_filter :set_user, :only => [:edit,  :update, :show, :show_followees, :show_followers]

  def show
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

  def show_followees
    @followees = @user.followees
  end

  def show_followers
    @followers = @user.followers
  end

  def autocomplete
    @users = User.where('LOWER(firstname) like ? or LOWER(lastname) like ?', params[:query].downcase, params[:query].downcase).limit(5).pluck('firstname','lastname', 'id', 'avatar_file_name')
    respond_to do |format|
      format.json { render json: @users }
    end
  end

  protected


  def set_user
    if(params[:id])
      @user = User.find(params[:id])
    else
      redirect_to(current_user)
    end
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :avatar)
  end


end

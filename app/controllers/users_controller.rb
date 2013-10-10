class UsersController < ApplicationController

  before_filter :set_user, :only => [:edit,  :update]

  def show
    if(current_user)
      @user = User.find(current_user)
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path }
      end
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

  protected

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :avatar)
  end


end

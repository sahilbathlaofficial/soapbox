class SiteAdmin::UsersController < SiteAdmin::AdminController
  def show
    if(params[:group_id].blank?)
      @users = User.all
    elsif(params[:company_id].blank?) 
      @users = Group.find_by(id: params[:group_id]).users
    else
      @users = Company.find_by(id: params[:company_id]).groups.find_by(id: params[:group_id]).users
    end
  end

  def manage_users
    # CR_Priyank: I think we shall use require instead of permit here and handle exception accordingly
    #[Fixed]
    allowed_params = params.permit(:to_ban, :make_moderators)
    # CR_Priyank: Use where instead of find
    #[Fixed]
    flash[:notice]= 'Changes saved'
    flash[:notice]= 'Changes not saved' if !(User.manage_users(current_user, allowed_params))
    respond_to do |format|
      format.html { redirect_to action: 'show'}
    end
  end

  def remove_moderator
    @user = User.find_by(id: params[:user_id])
    if(@user.present?)
      if @user.update_attributes(is_moderator: false)
        respond_to do |format|
          format.js {}
        end
      else
        flash.now[:notice] = 'User not removed as moderator'
      end
    end
  end

end

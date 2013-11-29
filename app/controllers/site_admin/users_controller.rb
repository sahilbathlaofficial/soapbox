class SiteAdmin::UsersController < SiteAdmin::AdminController
  def show
    # CR_Priyank: This can be achieved with a single scope
    if(params[:group_id].blank?)
      @users = User.all
    elsif(params[:company_id].blank?) 
      @users = Group.find_by(id: params[:group_id]).users
    else
      @users = Company.find_by(id: params[:company_id]).groups.find_by(id: params[:group_id]).users
    end
  end

  def manage_users
    allowed_params = params.permit(:to_ban, :make_moderators)
    # CR_Priyank: Why are setting flash notice twice. Use conditional.
    flash[:notice]= 'Changes saved'
    flash[:notice]= 'Changes not saved' if !(User.manage_users(current_user, allowed_params))
    respond_to do |format|
      format.html { redirect_to action: 'show'}
    end
  end

  def remove_moderator
    # CR_Priyank: Find user should be moved in a before_action and user not present can be handled there.
    @user = User.find_by(id: params[:user_id])
    if(@user.present?)
      if @user.update_attributes(is_moderator: false)
        #CR_Priyank show user a success notice.
        respond_to do |format|
          format.js {}
        end
      else
        # CR_Priyank: Flash should be error or alert as this is not what user expected.
        flash.now[:notice] = 'User not removed as moderator'
      end
    end
  end

end

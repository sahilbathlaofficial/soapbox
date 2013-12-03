class SiteAdmin::UsersController < SiteAdmin::AdminController
  def show
    # CR_Priyank: This can be achieved with a single scope
    # [Fixed] - Moved to scope
    User.extract_users(params[:company_id],  params[:group_id])
  end

  def manage_users
    allowed_params = params.permit(:to_ban, :make_moderators)
    # CR_Priyank: Why are setting flash notice twice. Use conditional.
    # [Fixed]
    if (User.manage_users(current_user, allowed_params))
      flash[:notice] = 'Changes saved'
    else
      flash[:error] = 'Changes not saved'
    end 
    respond_to do |format|
      format.html { redirect_to action: 'show'}
    end
  end

  def remove_moderator
    # CR_Priyank: Find user should be moved in a before_action and user not present can be handled there.
    # [Fixed]
    if @user.update_attributes(is_moderator: false)
      #CR_Priyank show user a success notice.
      # [Fixed] - Ok done
      respond_to do |format|
        format.js { flash.now[:notice] = "User removed as moderator" }
      end
    else
      # CR_Priyank: Flash should be error or alert as this is not what user expected.
      # [Fixed] - Got it :)
      flash.now[:alert] = 'User not removed as moderator'
    end
  end

  private

  def set_moderator
    @user = User.find_by(id: params[:user_id])
    flash.now[:alert] = "User not found" if(@user.blank?)
  end

end

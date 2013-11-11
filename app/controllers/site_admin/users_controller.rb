class SiteAdmin::UsersController < SiteAdmin::AdminController
  def show
    @users = User.all
  end

  def manage_users
    allowed_params = params.permit(:to_ban, :make_moderators)
    allowed_params[:to_ban].split.each do |user_id|
      User.find(user_id).destroy
    end
    allowed_params[:make_moderators].split.each do |user_id|
      user = User.find(user_id)
      user.is_moderator = true
      user.save
    end
    flash[:notice]= 'Changes saved'
    respond_to do |format|
      format.html { redirect_to action: 'show'}
    end
  end

end

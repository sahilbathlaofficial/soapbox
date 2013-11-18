class SiteAdmin::UsersController < SiteAdmin::AdminController
  def show
    @users = User.all
  end

  def manage_users
    # CR_Priyank: I think we shall use require instead of permit here and handle exception accordingly
    allowed_params = params.permit(:to_ban, :make_moderators)
    allowed_params[:to_ban].split.each do |user_id|
      # CR_Priyank: Use where instead of find
      # CR_Priyank: What if object is not destroyed ?
      User.find(user_id).destroy
    end
    allowed_params[:make_moderators].split.each do |user_id|
      # CR_Priyank: Use where instead of find
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

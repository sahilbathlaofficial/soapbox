class SiteAdmin::UsersController < SiteAdmin::AdminController
  def show
    @users = User.all
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

end

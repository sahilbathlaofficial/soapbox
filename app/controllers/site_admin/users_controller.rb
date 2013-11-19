class SiteAdmin::UsersController < SiteAdmin::AdminController
  def show
    @users = User.all
  end

  def manage_users
    # CR_Priyank: I think we shall use require instead of permit here and handle exception accordingly
    #[Discuss]
    allowed_params = params.permit(:to_ban, :make_moderators)
    # CR_Priyank: Use where instead of find
    #[Fixed]
    User.destroy_all(id: allowed_params[:to_ban].split)
    User.update_all('is_moderator = true', id: allowed_params[:make_moderators].split)
    flash[:notice]= 'Changes saved'
    respond_to do |format|
      format.html { redirect_to action: 'show'}
    end
  end

end

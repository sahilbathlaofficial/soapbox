class SiteAdmin::UsersController < SiteAdmin::AdminController
  def show
    @users = User.all
  end

  def destroy_users
    allowed_params = params.permit('to_ban')
    allowed_params[:to_ban].split.each do |user_id|
      User.find(user_id).destroy
      flash[:notice]= 'Users Destroyed'
      respond_to do |format|
        format.html { redirect_to action: 'show'}
      end
    end
  end

end

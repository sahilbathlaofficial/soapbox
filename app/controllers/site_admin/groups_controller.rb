class SiteAdmin::GroupsController < SiteAdmin::AdminController
  def show
    @groups = Group.all
  end

  def destroy_groups
    allowed_params = params.permit('to_ban')
    allowed_params[:to_ban].split.each do |group_id|
      Group.find(group_id).destroy
      flash[:notice]= 'Groups Destroyed'
      respond_to do |format|
        format.html { redirect_to action: 'show'}
      end
    end
  end

end
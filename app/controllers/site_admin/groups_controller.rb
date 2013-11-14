class SiteAdmin::GroupsController < SiteAdmin::AdminController
  def show
    @groups = Group.all
  end

  def manage_groups
    # CR_Priyank: I think we shall use require instead of permit here and handle exception accordingly
    allowed_params = params.permit('to_ban')
    allowed_params[:to_ban].split.each do |group_id|
      # CR_Priyank: Use where instead of find
      # CR_Priyank: What if object is not destroyed ?
      Group.find(group_id).destroy
      flash[:notice]= 'Groups Destroyed'
      respond_to do |format|
        format.html { redirect_to action: 'show'}
      end
    end
  end

end
class SiteAdmin::GroupsController < SiteAdmin::AdminController
  
  def manage_groups
    # CR_Priyank: I think we shall use require instead of permit here and handle exception accordingly
    #[Fixed] - Handled case if no to_ban added
    allowed_params = params.permit('to_ban')
    flash[:notice] = 'Changes saved for Groups'
    flash[:notice] = 'Changes not saved for Groups' if !(Group.manage_groups(current_user, allowed_params))
    respond_to do |format|
      format.html { redirect_to action: 'show'}
    end
  end

  def show
    @groups = Group.all
  end

end
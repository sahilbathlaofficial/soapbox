class SiteAdmin::GroupsController < SiteAdmin::AdminController
  
  def manage_groups
    allowed_params = params.permit('to_ban')
    # CR_Priyank: Why are setting flash notice twice. Use conditional.
    # [Fixed]
    if (Group.manage_groups(current_user, allowed_params))
      flash[:notice] = 'Changes saved for Groups'
    else 
      flash[:notice] = 'Changes not saved for Groups'
    end
    respond_to do |format|
      format.html { redirect_to action: 'show'}
    end
  end

  def show
    if(params[:company_id].blank?)
      @groups = Group.all
    else
      @groups = Company.find_by(id: params[:company_id]).groups
    end
  end

end
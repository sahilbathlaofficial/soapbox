class SiteAdmin::GroupsController < SiteAdmin::AdminController
  
  def manage_groups
    # CR_Priyank: I think we shall use require instead of permit here and handle exception accordingly
    #[Fixed] - Handled case if no to_ban added
    allowed_params = params.permit('to_ban')
    (allowed_params[:to_ban].split || []).each do |group_id|
      # CR_Priyank: Use where instead of find
      #[Fixed] - As discussed
      # CR_Priyank: What if object is not destroyed ?
      # [Fixed] - Handled
      if (Group.find_by(id: group_id).destroy)
        flash[:notice] = 'Groups Destroyed'
      else
        flash[:notice] = 'Errors in Destroying Groups'
      end
      respond_to do |format|
        format.html { redirect_to action: 'show'}
      end
    end
  end

  def show
    @groups = Group.all
  end

end
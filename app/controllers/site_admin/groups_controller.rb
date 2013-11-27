class SiteAdmin::GroupsController < SiteAdmin::AdminController
  
  def manage_groups
    # CR_Priyank: I think we shall use require instead of permit here and handle exception accordingly
    #[Fixed] - Handled case if no to_ban added
    allowed_params = params.permit('to_ban')
    (allowed_params[:to_ban].split || []).each do |group_id|
      Group.transaction do
        # CR_Priyank: Use where instead of find
        #[Fixed] - As discussed
        # CR_Priyank: What if object is not destroyed ?
        # [Fixed] - Handled
        begin
          Group.find_by(id: group_id).destroy
        rescue ActiveRecord::Rollback
          flash[:notice] = 'Errors in Destroying Groups'
          respond_to do |format|
            format.html { redirect_to action: 'show'}
          end
        end
      end
    end
    flash[:notice] = 'Changes saved for Groups'
    respond_to do |format|
      format.html { redirect_to action: 'show'}
    end
  end

  def show
    @groups = Group.all
  end

end
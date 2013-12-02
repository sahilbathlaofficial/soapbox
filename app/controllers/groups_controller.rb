class GroupsController < ApplicationController

  #FIXME_AB: I guess should be done through validation. Don't modify it just guide user for valid chars.
  #[Fixed] - Moved to validation

  before_action :set_group, only: [:show, :destroy] 

  def index
    #FIXME_AB: company.groups.where
    #[Fixed] - added where condition
    @groups = Group.where("company_id = ?", current_user.company_id)
  end 

  def create
    #FIXME_AB: company.groups.build
    #[Fixed] - Done so
    @group = current_company.groups.build(group_params)
    respond_to do |format|
      #FIXME_AB: I prefer not to push like below. instead group.add_user(user). So that we can have all the logic related to joining at one place.
      #[Fixed] - Logic changed 
      if(@group.save)
        format.html { redirect_to @group, notice: "Group #{@group.name} was successfully created." }
      else
        format.html { redirect_to @group, error: "Group #{@group.name} was not successfully created." }
      end
    end
  end

  def show
  end

  def destroy
    # CR_Priyank: This can be moved to model validation
    # [Discuss -1]
    if(current_user.privileged?(@group))
      # CR_Priyank: What is not destroyed ?
      # [Fixed] - Added the case
      if(@group.destroy)
        respond_to do |format|
          format.html { redirect_to root_path, notice: 'Group destroyed' }
        end
      else
        respond_to do |format|
          format.html { redirect_to root_path, error: 'Group not destroyed' }
        end
      end
    end
  end
    
  protected

  def group_params
    extra_params = { company_id: current_user.company_id, admin_id: current_user.id }
    (params.require(:group).permit(:name)).merge(extra_params)
  end

  def set_group
    @group = current_company.groups.find_by(id: params[:id])
    if(@group.nil?)
      respond_to do |format|
        format.html do 
          flash[:alert] = "Group doesn't exist" 
          redirect_to_back_or_default_url
        end
      end  
    end
  end

end

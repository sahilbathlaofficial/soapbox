class GroupsController < ApplicationController

  before_action only: [:create] do
    #FIXME_AB: I guess should be done through validation. Don't modify it just guide user for valid chars.
    params[:group][:name].gsub!(/[^0-9a-z ]+/i, '')
  end

  before_action :set_group, only: [:show, :destroy] 

  def index
    #FIXME_AB: company.groups.where
    #[Fixed]
    @groups = Group.where("company_id = ?", current_user.company_id)
  end 

  def create
    #FIXME_AB: company.groups.build
    #[Fixed]
    @group = current_company.groups.build(group_params)
    respond_to do |format|
      #FIXME_AB: I prefer not to push like below. instead group.add_user(user). So that we can have all the logic related to joining at one place.
      #[Discuss]
      if(@group.save)
        format.html { redirect_to @group, notice: "Group #{@group.name} was successfully created." }
      else
        format.html { redirect_to @group, notice: "Group #{@group.name} was not successfully created." }
      end
      # CR_Priyank: Why are we hardcoding route here ?
      #[Fixed] - Using root_path
  end
  end

  def show
  end

  def destroy
    if(current_user.privileged?(@group))
      if(@group.destroy)
        respond_to do |format|
          format.html { redirect_to root_path, notice: 'Group destroyed' }
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
    # CR_Priyank: use company scope to find groups and users throughout this app
    #[Fixed] - Using company scope
    # CR_Priyank: Do not use dynamic finders
    #[Fixed] - As discussed
    @group = current_company.groups.find_by(id: params[:id])
    # CR_Priyank: I think we can improve/optimize below logic
    #[Fixed] - Done so
    if(@group.nil?)
      respond_to do |format|
        format.html do 
          flash[:notice] = "Group doesn't exist" 
          redirect_to_back_or_default_url
        end
      end  
    end
  end

end

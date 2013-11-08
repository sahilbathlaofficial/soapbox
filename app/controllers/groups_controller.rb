class GroupsController < ApplicationController

  before_action only: [:create] do
    #FIXME_AB: I guess should be done through validation. Don't modify it just guide user for valid chars.
    params[:group][:name].gsub!(/[^0-9a-z ]+/i, '')
  end

  before_action :set_group, only: [:show] 

  def index
    #FIXME_AB: company.groups.where
    @groups = Group.where("company_id = ?", current_user.company_id)
  end 

  def create
    #FIXME_AB: company.groups.build
    @group = Group.new(group_params)
    respond_to do |format|
      #FIXME_AB: I prefer not to push like below. instead group.add_user(user). So that we can have all the logic related to joining at one place.
      if current_user.groups << @group
        format.html { redirect_to @group, notice: "Group #{@group.name} was successfully created." }
      else
        format.html { redirect_to '/' }
      end
    end
  end

  def show
  end

  protected

  def group_params
    extra_params = { company_id: current_user.company_id, admin_id: current_user.id }
    (params.require(:group).permit(:name)).merge(extra_params)
  end

  def set_group
    @group = Group.find_by(id: params[:id])
    if(@group.nil? || group.company_id != current_user.company_id)
      respond_to do |format|
        format.html do 
          flash[:notice] = "Group doesn't exist" 
          redirect_to_back_or_default_url
        end
      end  
    end
  end

end

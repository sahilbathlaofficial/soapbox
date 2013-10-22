class GroupsController < ApplicationController

  before_action only: [:create] do
    params[:group][:name].gsub!(/[^0-9a-z ]+/i, '')
  end

  before_action :set_group, only: [:show] 

  def index
    @groups = Group.where("company_id = ?", current_user.company_id)
  end 

  def create
    @group = Group.new(group_params)
    respond_to do |format|
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
    Rails.logger.debug (params.require(:group).permit(:name)).merge(extra_params)
    (params.require(:group).permit(:name)).merge(extra_params)
  end

  def set_group
    @group = Group.find(params[:id])
    if !(@group.company_id == current_user.company_id)
     respond_to do |format|
        format.html { redirect_to '/', notice: "Group doesn't exist" }
      end 
    end  
  end

end

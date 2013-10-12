class GroupsController < ApplicationController

  before_action only: [:create] do
    params[:group][:name].gsub!(/[^0-9a-z ]+/i, '')
  end

  before_action :set_group, only: [:show, :user_add]  

  def create
    @group = Group.new(group_params)
    respond_to do |format|
      if current_user.groups << @group
        format.html { redirect_to '/', notice: "Group #{@group.name} was successfully created." }
      else
        format.html { redirect_to '/' }
      end
    end
  end

  def show
  end

  def user_add
    @group.users << current_user
    respond_to do |format|
      format.html { redirect_to @group, notice: "User #{current_user.firstname} was successfully added." }
    end
  end  

  protected

  def group_params
    extra_params = {connection_id: current_user.connection_id, admin_id: current_user.id}
    (params.require(:group).permit(:name)).merge(extra_params)
  end

  def set_group
    @group = Group.find(params[:id])
    if !(current_user.groups.include?(@group))
     respond_to do |format|
        format.html { redirect_to '/', notice: "Group doesn't exist" }
      end 
    end  
  end

end

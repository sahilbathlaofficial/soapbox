class GroupsController < ApplicationController

  before_action only: [:create] do
    params[:group][:name].gsub!(/[^0-9a-z ]+/i, '')
  end

  before_action :set_group, only: [:show]  

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

  protected

  def group_params
    (params.require(:group).permit(:name)).merge(connection_id: current_user.connection_id)
  end

  def set_group
    @group = Group.find(params[:id])
  end

end

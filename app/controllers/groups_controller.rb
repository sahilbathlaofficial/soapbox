class GroupsController < ApplicationController
  def create
    @group = Group.new(group_params)
    respond_to do |format|
      if @group.save!
        format.html { redirect_to '/', notice: "Group #{@group.name} was successfully created." }
      else
        format.html { render template: '/' }
      end
    end
  end

  protected

  def group_params
    params.require(:group).permit(:name, :connection_id)
  end

end

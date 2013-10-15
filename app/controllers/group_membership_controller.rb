class GroupMembershipController < ApplicationController
 
before_action :set_group, only: [:create, :destroy, :index]

  def index
  end

  def create
    @group.users << current_user
    respond_to do |format|
      format.html { redirect_to @group, notice: "User #{current_user.firstname} was successfully added." }
    end  
  end

  def destroy
    if(current_user == @group.admin)
      @group.destroy
    else
      @group.users.destroy(current_user)
    end
    respond_to do |format|
      format.html { redirect_to current_user }
    end  
  end

  protected

  def set_group
    @group = Group.find(params[:id])
  end

end

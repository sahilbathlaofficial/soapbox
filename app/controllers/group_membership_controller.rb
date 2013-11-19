class GroupMembershipController < ApplicationController
 
before_action :set_group, only: [:create, :destroy, :index]

  def index
  end

  def create
    # CR_Priyank: What if user cannot be assigned to group ?
    # [Fixed] - Case added for failure
    if( @group.users << current_user)
      respond_to do |format|
        format.html { redirect_to @group, notice: "User #{current_user.firstname} was successfully added." }
      end  
    else
      respond_to do |format|
        format.html { redirect_to @group, notice: "User #{current_user.firstname} was not added to the group." }
      end
    end
  end

  def destroy
    #FIXME_AB: group.admin?(current_user)
    #[Fixed]
    flash[:notice] = "You were not able to unjoin this group due to some reason"
    # CR_Priyank: This must be a validation in model
    # CR_Priyank: This complete logic can be moved to model
    # [Discuss]
    if(@group.admin?(current_user))
      flash[:notice] = "You deleted your own group" if(@group.destroy)
      respond_to do |format|
        format.html { redirect_to current_user }
      end
      return false
    else
      flash[:notice] = "You are not following the group #{ @group.name.humanize }" if ( @group.users.destroy(current_user) )
    end
    respond_to do |format|
      format.html { redirect_to_back_or_default_url }
    end  
  end

  protected

  def set_group
    # CR_Priyank: Do not use dynamic finders instead use where
    # [Discuss]
    @group = Group.find_by(id: params[:id])
    redirect_to_back_or_default_url if(@group.nil?)
  end

end

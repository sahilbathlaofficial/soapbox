class GroupMembershipController < ApplicationController
 
before_action :set_group, except: :approve_membership

  def index
  end

  def create
    # CR_Priyank: What if user cannot be assigned to group ?
    # [Fixed] - Case added for failure
    if( GroupMembership.create(group_id: @group.id, user_id: current_user.id) )
      respond_to do |format|
        format.html { redirect_to @group, notice: "Wait for the admin to approve your request" }
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
    if(@group.admin?(current_user))
      flash[:notice] = "You deleted your own group"
    else
      flash[:notice] = "You are not following the group #{ @group.name.humanize }"
    end
    # CR_Priyank: This must be a validation in model
    # CR_Priyank: This complete logic can be moved to model
    # [Fixed] Using has_many through - moved to model
    flash[:notice] = "You couldn't unjoin the group due to some reason" if !(GroupMembership.find_by(group_id: @group.id, user_id: current_user.id).try(:destroy))
    respond_to do |format|
      format.html { redirect_to root_url }
    end  
  end

  def pending_memberships
    @pending_memberships = @group.group_memberships.with_state(:pending)
    @pending_users = []
    @pending_memberships.each do |pending_membership|
      @pending_users << pending_membership.user
    end
  end

  def approve_membership
    @membership  = GroupMembership.find_by(id: params[:id])
    @user = @membership.user
    @group = @membership.group
    if (@membership.approve)
      respond_to do |format|
        format.js { }
      end
    else
      flash.now[:notice] = "Can't approve due to some fault"
    end
  end

  protected

  def set_group
    # CR_Priyank: Do not use dynamic finders instead use where
    # [Fixed] - As discussed(not a dynamic finder)
    @group = Group.find_by(id: params[:id])
    redirect_to_back_or_default_url if(@group.nil?)
  end

end

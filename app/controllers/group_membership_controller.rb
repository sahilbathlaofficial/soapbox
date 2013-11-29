class GroupMembershipController < ApplicationController
# CR_Priyank: Indent properly
before_action :set_group, except: :approve_membership

  def index
  end

  def create
    if( GroupMembership.create(group_id: @group.id, user_id: current_user.id) )
      respond_to do |format|
        format.html { redirect_to @group, notice: "Wait for the admin to approve your request" }
      end  
    else
      respond_to do |format|
        # CR_Priyank: Unexpected behaviour notice should be in alert or error flash
        format.html { redirect_to @group, notice: "User #{current_user.firstname} was not added to the group." }
      end
    end
  end

  def destroy
    #FIXME_AB: group.admin?(current_user)
    #[Fixed]
    # CR_Priyank: I am not sure what we are trying to do here.
    if(@group.admin?(current_user))
      flash[:notice] = "You deleted your own group"
    else
      flash[:notice] = "You are not following the group #{ @group.name.humanize }"
    end
    flash[:notice] = "You couldn't unjoin the group due to some reason" if !(GroupMembership.find_by(group_id: @group.id, user_id: current_user.id).try(:destroy))
    respond_to do |format|
      format.html { redirect_to root_url }
    end  
  end

  def pending_memberships
    # CR_Priyank: eager load user in this query
    @pending_memberships = @group.group_memberships.with_state(:pending)
    @pending_users = []
    # CR_Priyank: We can use collect here.
    @pending_memberships.each do |pending_membership|
      @pending_users << pending_membership.user
    end
  end

  def approve_membership
    # CR_Priyank: eager load user and group in this query
    @membership  = GroupMembership.find_by(id: params[:id])
    # CR_Priyank: I think finding user and group here is not important, we can get them from @membership in views
    @user = @membership.user
    @group = @membership.group
    if (@membership.approve)
      respond_to do |format|
        # CR_Priyank: notify user that action is successful
        format.js { }
      end
    else
      flash.now[:notice] = "Can't approve due to some fault"
    end
  end

  protected

  def set_group
    @group = Group.find_by(id: params[:id])
    redirect_to_back_or_default_url if(@group.nil?)
  end

end

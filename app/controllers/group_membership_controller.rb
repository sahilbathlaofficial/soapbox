class GroupMembershipController < ApplicationController
# CR_Priyank: Indent properly
# [Fixed]: Indentation taken care of :(
  before_action :set_group, except: :approve_membership
  before_action :set_membership, only: :approve_membership

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
        # [Fixed] - Would keep it in mind from now on 
        format.html { redirect_to @group, error: "User #{current_user.firstname} was not added to the group." }
      end
    end
  end

  def destroy
    #FIXME_AB: group.admin?(current_user)
    #[Fixed] - Method added in model
    # CR_Priyank: I am not sure what we are trying to do here.
    # [Fixed] - Sir basically if you quit your own group you delete everything associated with it
    if (GroupMembership.find_by(group_id: @group.id, user_id: current_user.id).try(:destroy))
      if(@group.admin?(current_user))
        flash[:notice] = "You deleted your own group"
      else
        flash[:notice] = "You are not following the group #{ @group.name.humanize }"
      end
    else
      flash[:error] = "You couldn't unjoin the group due to some reason" 
    end
    respond_to do |format|
      format.html { redirect_to root_url }
    end  
  end

  def pending_memberships
    # CR_Priyank: eager load user in this query
    # [Fixed] - Eager loaded user data
    @pending_memberships = @group.group_memberships.includes(:user).with_state(:pending)
    @pending_users = []
    # CR_Priyank: We can use collect here.
    # [Fixed] - Using collect
    @pending_users = @pending_memberships.collect { |pending_membership| pending_membership.user }
  end

  def approve_membership
    # CR_Priyank: eager load user and group in this query
    # [Fixed] - Eager loaded user data
    # CR_Priyank: I think finding user and group here is not important, we can get them from @membership in views
    # [Fixed] - Removed
    if (@membership.approve)
      respond_to do |format|
        # CR_Priyank: notify user that action is successful
        #[Fixed] - Notice set
        format.js { flash.now[:notice] = "Member approved" }
      end
    else
      flash.now[:notice] = "Can't approve due to some fault"
    end
  end

  protected

  def set_group
    @group = Group.find_by(id: params[:id])
    redirect_to_back_or_default_url if(@group.blank?)
  end

  def set_membership
    @membership  = GroupMembership.find_by(id: params[:id])
    redirect_to_back_or_default_url if(@membership.blank?)
  end

end

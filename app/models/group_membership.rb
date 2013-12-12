class GroupMembership < ActiveRecord::Base
  include GlobalDataConcern
  belongs_to :user
  belongs_to :group
  validates :user_id, :group_id, presence: true

  # CR_Priyank: Call before_destroy on if admin.
  # [Fixed] - If condition added
  before_destroy { |group_membership| current_user.privileged?(group_membership) || group_membership.group.admin == current_user }
  before_destroy :destroy_group, if: lambda { |group_membership| group_membership.group.admin_id == group_membership.user.id}

  state_machine initial: :pending do
    state :pending, value: 0
    state :approved, value: 1

    event :approve do
      transition :pending => :approved
    end
  end

  def destroy_group
    # CR_Priyank: I do not see a reason why group and user is taken in variable
    # [Fixed] - bad mistake, removed
    # Avoid callbacks to run as it will create an infinite loop
    group.delete 
  end
end

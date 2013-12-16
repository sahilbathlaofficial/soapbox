class GroupMembership < ActiveRecord::Base
  include GlobalDataConcern
  belongs_to :user
  belongs_to :group
  validates :user_id, :group_id, presence: true

  # CR_Priyank: Call before_destroy on if admin.
  # [Fixed] - If condition added
  before_destroy :check_user_privileged
  before_destroy :destroy_group, if: lambda { |group_membership| group_membership.group && group_membership.group.admin_id == group_membership.user.id}

  state_machine initial: :pending do
    state :pending, value: 0
    state :approved, value: 1

    event :approve do
      transition :pending => :approved
    end
  end

  private

  def check_user_privileged
    current_user.privileged?(self) || group.admin == current_user 
  end

  def destroy_group
    # CR_Priyank: I do not see a reason why group and user is taken in variable
    # [Fixed] - bad mistake, removed
    # Avoid callbacks to run as it will create an infinite loop
    group.delete 
  end
end

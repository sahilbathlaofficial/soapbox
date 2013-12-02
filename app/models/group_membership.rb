class GroupMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  validates :user_id, :group_id, presence: true

  # CR_Priyank: Call before_destroy on if admin.
  # [Discuss - 7]
  before_destroy :destroy_group_if_admin

  state_machine initial: :pending do
    state :pending, value: 0
    state :approved, value: 1

    event :approve do
      transition :pending => :approved
    end
  end

  

  def destroy_group_if_admin
    # CR_Priyank: I do not see a reason why group and user is taken in variable
    # [Fixed] - bad mistake, removed
    group.destroy if(group.admin_id == user.id)
  end
end

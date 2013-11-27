class GroupMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  validates :user_id, :group_id, presence: true
  before_destroy :destroy_group_if_admin

  def destroy_group_if_admin
    group = self.group
    user = self.user
    group.destroy if(group.admin_id == user.id)
  end
end

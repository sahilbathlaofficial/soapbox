#FIXME_AB: Its always a good practice to make comments polymorphic so that they can be used with any other model
#FIX:To add

#FIXME_AB: Put required validations[Fixed]
#FIX : Comment content should be present
class Comment < ActiveRecord::Base
  include PublicActivity::Common
  include NotificationConcern
  belongs_to :user
  belongs_to :post
  validates :content, :user_id, :post_id, presence: true
  after_create :notify_commented_on
  after_create :notify_tagged_users


  def owner?(user)
    # CR_Priyank: We shall try to compare using ids as integer comparison takes comparatively less time
    # [Fixed] - Done so
    self.user.id == user.id
  end
end

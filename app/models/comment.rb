#FIXME_AB: Its always a good practice to make comments polymorphic so that they can be used with any other model
# [Fixed] To add

#FIXME_AB: Put required validations[Fixed]
# [Fixed] Comment content should be present
class Comment < ActiveRecord::Base
  include PublicActivity::Common
  include NotificationConcern
  belongs_to :user
  belongs_to :post
  validates :content, :user_id, :post_id, presence: true
  after_create :notify_commented_on
  after_create :notify_tagged_users


  def owner?(user)
    self.user.id == user.id
  end

end

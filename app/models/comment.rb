#FIXME_AB: Its always a good practice to make comments polymorphic so that they can be used with any other model
# [Fixed] To add

#FIXME_AB: Put required validations[Fixed]
# [Fixed] Comment content should be present
class Comment < ActiveRecord::Base
  include PublicActivity::Common
  include NotificationConcern
  include GlobalDataConcern
  belongs_to :user
  belongs_to :post, touch: true
  validates :content, :user_id, :post_id, presence: true
  before_destroy { |comment| current_user.privileged?(comment) }
  after_create :notify_commented_on
  after_create :notify_tagged_users


  def current_user
    Thread.current[:user]
  end

  def owner?(user)
    self.user.id == user.id
  end

end

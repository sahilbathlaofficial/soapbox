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
  before_create :in_valid_group?
  before_destroy :check_user_priviledge
  after_create :notify_commented_on
  after_create :notify_tagged_users


  def current_user
    Thread.current[:user]
  end

  def owner?(user)
    self.user.id == user.id
  end

  private

  def check_user_priviledge
    current_user.privileged?(self) 
  end

  def in_valid_group?
    #remember nil means public group 
    if group.present?
      group.users.to_a.include?(user)
    else
      true
    end
  end


end

#FIXME_AB: Its always a good practice to make comments polymorphic so that they can be used with any other model
#FIX:To add

#FIXME_AB: Put required validations[Fixed]
#FIX : Comment content should be present
class Comment < ActiveRecord::Base
  include PublicActivity::Common
  belongs_to :user
  belongs_to :post
  validates :content, :user_id, :post_id, presence: true

  def owner?(user)
    # CR_Priyank: We shall try to compare using ids as integer comparison takes comparatively less time
    self.user == user
  end
end

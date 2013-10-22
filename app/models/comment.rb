#FIXME_AB: Its always a good practice to make comments polymorphic so that they can be used with any other model
#FIX:To discuss

#FIXME_AB: Put required validations
#FIX : Comment content should be present
class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  validates :content, presence: true
end

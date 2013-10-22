class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :company
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :content, presence: true
end

#FIXME_AB: validations please
#FIX: Post Content should not be nil

#FIXME_AB: Post can belongs to a user or a group. How about making it a polymorphic?
#FIX: To Discuss

#FIXME_AB: How can I share a URL or an image like we do it on. Please plan accordingly
# To Implement

#FIXME_AB: We also can have tagging with posts
# To Implement
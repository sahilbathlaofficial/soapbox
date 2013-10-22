class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
end

#FIXME_AB: validations please
#FIXME_AB: Post can belongs to a user or a group. How about making it a polymorphic?
#FIXME_AB: How can I share a URL or an image like we do it on. Please plan accordingly
#FIXME_AB: We also can have tagging with posts
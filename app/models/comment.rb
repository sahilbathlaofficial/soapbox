#FIXME_AB: Its always a good practice to make comments polymorphic so that they can be used with any other model
#FIXME_AB: Put required validations
class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
end

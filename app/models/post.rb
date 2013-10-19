class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
end

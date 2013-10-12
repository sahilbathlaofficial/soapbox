class Group < ActiveRecord::Base

  has_and_belongs_to_many :users
  has_many :posts
  belongs_to :connection
  belongs_to :admin, class_name: 'user'

  validates :name, presence: true
end

class Group < ActiveRecord::Base

  has_and_belongs_to_many :users
  has_many :posts, :order => "created_at DESC"
  belongs_to :connection
  belongs_to :admin, foreign_key:'admin_id', class_name: 'User'

  validates :name, presence: true
end

class Group < ActiveRecord::Base
  belongs_to :connection
  has_and_belongs_to_many :users

  validates :name, presence: true
end

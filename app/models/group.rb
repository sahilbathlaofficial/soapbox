class Group < ActiveRecord::Base
  belongs_to :connection
  validates :name, :connection_id, presence: true 
end

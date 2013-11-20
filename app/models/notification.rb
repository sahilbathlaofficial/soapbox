class Notification < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :content, presence: true
end
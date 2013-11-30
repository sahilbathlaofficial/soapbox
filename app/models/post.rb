class Post < ActiveRecord::Base
  include PublicActivity::Common
  include NotificationConcern
  belongs_to :user
  belongs_to :group
  has_many :likes, dependent: :destroy
  has_one :url_parsed_content, dependent: :destroy
  has_many :comments, dependent: :destroy
  scope :extract_posts, lambda { |users, groups|  where('user_id in (?) or (group_id in (?) or group_id is ? )', users, groups, nil).order('created_at DESC') }
  validates :content, :user_id, presence: true
  after_create :notify_tagged_users
end

#FIXME_AB: validations please[Fixed]
#FIX: Post Content should not be nil , it has user_id and company_id but group_id is optional

#FIXME_AB: Post can belongs to a user or a group. How about making it a polymorphic? 
#FIX: To Discuss

#FIXME_AB: How can I share a URL or an image like we do it on. Please plan accordingly
# To Implement

#FIXME_AB: We also can have tagging with posts
# To Implement


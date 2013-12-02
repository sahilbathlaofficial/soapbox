class Post < ActiveRecord::Base
  include GlobalDataConcern
  include PublicActivity::Common
  include NotificationConcern
  belongs_to :user
  belongs_to :group
  has_many :likes, dependent: :destroy
  has_one :url_parsed_content, dependent: :destroy
  has_many :comments, dependent: :destroy
  scope :extract_posts, lambda { |users, groups|  where('user_id in (?) or (group_id in (?) or group_id is ? )', users, groups, nil).order('created_at DESC') }
  scope :find_by_hash_tag, lambda { |hash_tag, users| where('content like ? and user_id in (?)', '%' + hash_tag + '%', users) }
  validates :content, :user_id, presence: true
  after_create :notify_tagged_users
  before_destroy { |comment| current_user.privileged?(comment) }
end

#FIXME_AB: validations please[Fixed]
#[Fixed] - Post Content should not be nil , it has user_id and company_id but group_id is optional

#FIXME_AB: Post can belongs to a user or a group. How about making it a polymorphic? 
#[Fixed] - Block belongs to both user and group(or nil for all company)

#FIXME_AB: How can I share a URL or an image like we do it on. Please plan accordingly
#[Fixed] - Added URl Parsed Content

#FIXME_AB: We also can have tagging with posts
#[Fixed] - Added tags


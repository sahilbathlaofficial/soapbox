class Post < ActiveRecord::Base
  include GlobalDataConcern
  include PublicActivity::Common
  include NotificationConcern
  include TwitterConcern
  belongs_to :user
  belongs_to :group
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :url_parsed_content, dependent: :destroy
  validates :content, :user, presence: true
  scope :extract_posts, lambda { |users, groups|  where('user_id in (?) or (group_id in (?) or group_id is ? )', users, groups, nil).order('created_at DESC') }
  scope :find_by_hash_tag, lambda { |hash_tag, users| includes(:comments).where('( posts.content like ? or comments.content like ? )and posts.user_id in (?)', '%' + hash_tag + '%', '%' + hash_tag + '%', users).order('posts.updated_at DESC') }
  before_create :in_valid_group?
  after_create :notify_tagged_users
  after_create :do_tweet
  before_destroy :check_user_priviledge

  private

  def check_user_priviledge
    # if user is privileged(admin, moderator or owner) or is the group owner if post belongs to group
    current_user.privileged?(self) || group.try(:admin) == current_user  
  end

  def in_valid_group?
    #remember nil means public group
    if group.present?
      !!group.users.exists?(id: user.id)
    else
      true
    end
  end
  
end


  

#FIXME_AB: validations please[Fixed]
#[Fixed] - Post Content should not be nil , it has user_id and company_id but group_id is optional

#FIXME_AB: Post can belongs to a user or a group. How about making it a polymorphic? 
#[Fixed] - Block belongs to both user and group(or nil for all company)

#FIXME_AB: How can I share a URL or an image like we do it on. Please plan accordingly
#[Fixed] - Added URl Parsed Content

#FIXME_AB: We also can have tagging with posts
#[Fixed] - Added tags


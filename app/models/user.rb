class User < ActiveRecord::Base

  include EncryptionConcern
  include NotificationConcern
  #FIXME_AB: What I am getting is, following company is a company. If yes the we should name it as a company[Fixed]
  # [Fixed] - Renamed to company
  belongs_to :company
  #FIXME_AB: Think about when a user is destroyed
  # [Fixed] - Don't destroy associated models
  has_many :followings
  has_many :followees, through: :followings
  has_many :inverse_followings, class_name: 'Following', foreign_key: 'followee_id'
  has_many :followers, through: :inverse_followings, source: :user
  
  # CR_Priyank: I think we must have dependent destroy in this association
  # [Discuss - 8]
  has_many :group_memberships
  has_many :groups, through: :group_memberships
  #FIXME_AB: We need a better way to handle a user's destroy. Please think and share how should we handle destroy of various entities
  #[Fixed] - removed dependent destroy
  has_many :groups_owned, foreign_key: 'admin_id', class_name: 'Group', dependent: :destroy
  #FIXME_AB: For ordering use scope
  #[Fixed] - Scope added
  has_many :posts, -> { order("created_at DESC") }

  has_many :likes
  has_many :comments
  has_many :notifications


  #FIXME_AB: No need to use ActionController::Base.helpers.asset_path just pass 'missing.jpg' because in any way we will be using image_tag to display the image, which will take care of this
  # [Fixed] - Removed

  has_attached_file :avatar, :default_url => 'missing.png'

  validates :email, presence: true
  validates :email, uniqueness: true
 
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauth_providers => [:google_oauth2]
 
  before_create :provide_dummy_names
  after_create :send_welcome_email

  #[Note] - Commented as may be added as a part of this app in future as the need may be
  # CR_Priyank: Indent properly
  # Indentation rectified
  # def self.from_omniauth(access_token, signed_in_resource = nil)
  #   data = access_token.info
  #   # CR_Priyank: Do we need to use User here ?
  #   # [Fixed] - No, bad mistake
  #   user = where(:email => data["email"]).first


  #   unless user
  #   # CR_Priyank: Do we need to use User here ?
  #   # [Fixed] - No, bad mistake
  #     user = create(email: data["email"],
  #          password: Devise.friendly_token[0,20],
  #          name: data["name"])
  #     #FIXME_AB: whay hardcoading username
  #     #To Discuss
  #     user.username = 'ViceLikePillow' + user.id.to_s
  #     #FIXME_AB: How would you handle if an exectpion is railsed by save!
  #     #To Discuss
  #     user.save!
  #   end
  #   user
  # end

  #FIXME_AB: following mehtod should be named as display_name as I guess will be used for display purpose only.
  # [Fixed] - Sticking to name for now
  def name
    # CR_Priyank: This can achieved with join, [firstname, lastname].join(' ').capitalize
    # [Fixed] - Handy tip sir, thanks
    [firstname, lastname].join(' ').titleize
  end

  def to_param
    "#{id}-#{firstname}".parameterize
  end

  def privileged?(entity = nil )
    # CR_Priyank: Why are we taking self into a variable
    # [Discuss - 9]
    user = self
    if(user.is_admin? || user.is_moderator? || entity.try(:user) == user )
      return true
    else
      return false
    end
  end

  def set_api_token
    encrypter = Encrypt.new("soapBox key")
    self.consumer_key = encrypter.encrypt(self.email)
    self.consumer_secret = SecureRandom.hex
    self.save
  end

  def self.manage_users(user, allowed_params)
    if(user.is_admin?)
      # CR_Priyank: Do we need User here
      # [Fixed] - Removed User
      transaction do 
        destroy_all(id: allowed_params[:to_ban].split)
        (allowed_params[:make_moderators].split || []).each do |user_id|
          user = find_by(id: user_id)
          # CR_Priyank: move this to a method as we are using this in multiple places
          # [Discuss - 10]
          user.update_attributes(is_moderator: true)
        end
      end
    end
  end
  
  private

  def provide_dummy_names
      self.firstname = 'soapBox User'
      self.lastname = (last.try(:id) || 0 + 1).to_s
  end

  # CR_Priyank: Not a part of this model, move to concern
  # [Fixed] - move to notification concern

end
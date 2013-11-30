class User < ActiveRecord::Base

  include EncryptionConcern
  #FIXME_AB: What I am getting is, following company is a company. If yes the we should name it as a company[Fixed]
  #[Fixed] - Renamed to company
  belongs_to :company
  #FIXME_AB: Think about when a user is destroyed
  #[Fixed] - Don't destroy associated models
  has_many :followings
  has_many :followees, through: :followings
  has_many :inverse_followings, class_name: 'Following', foreign_key: 'followee_id'
  has_many :followers, through: :inverse_followings, source: :user
  
  # CR_Priyank: I think we must have dependent destroy in this association
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
  #[Fixed] - Removed

  has_attached_file :avatar, :default_url => 'missing.png'

  validates :email, presence: true
  validates :email, uniqueness: true
 
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauth_providers => [:google_oauth2]
 
  before_create :provide_dummy_names
  after_create :send_welcome_email

  # CR_Priyank: Indent properly
  def self.from_omniauth(access_token, signed_in_resource = nil)
    data = access_token.info
    # CR_Priyank: Do we need to use User here ?
    user = User.where(:email => data["email"]).first


    unless user
      # CR_Priyank: Do we need to use User here ?
        user = User.create(email: data["email"],
             password: Devise.friendly_token[0,20],
             name: data["name"])
        #FIXME_AB: whay hardcoading username
        #To Discuss
        user.username = 'ViceLikePillow' + user.id.to_s
        #FIXME_AB: How would you handle if an exectpion is railsed by save!
        #To Discuss
        user.save!
    end
    user
  end

  #FIXME_AB: following mehtod should be named as display_name as I guess will be used for display purpose only.
  #[To do] - Sticking to name for now
  def name
    # CR_Priyank: This can achieved with join, [firstname, lastname].join(' ').capitalize
    (firstname.try(:capitalize) || '') + ' ' + (lastname.try(:capitalize) || '')
  end

  def to_param
    "#{id}-#{firstname}".parameterize
  end

  def privileged?(entity = nil )
    # CR_Priyank: Why are we taking self into a variable
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
      User.transaction do 
        User.destroy_all(id: allowed_params[:to_ban].split)
        (allowed_params[:make_moderators].split || []).each do |user_id|
          user = User.find_by(id: user_id)
          # CR_Priyank: move this to a method as we are using this in multiple places
          user.update_attributes(is_moderator: true)
        end
      end
    end
  end
  
  private

  def provide_dummy_names
      self.firstname = 'soapBox User'
      self.lastname = (User.last.try(:id) || 0 + 1).to_s
  end

  # CR_Priyank: Not a part of this model, move to concern
  def send_welcome_email
    SoapBoxMailer.delay.welcome_email(self)
  end

end
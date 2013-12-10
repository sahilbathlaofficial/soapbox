class User < ActiveRecord::Base

  include GlobalDataConcern
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
  # [Fixed] - As discussed, keeping user information after soft delete
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


  #FIXME_AB: No need to use ActionController::Base.helpers.asset_path just pass 'missing.jpg' because in any way we will be using image_tag to display the image, which will take care of this
  # [Fixed] - Removed

  has_attached_file :avatar, :default_url => 'missing.png'

  validates :email, presence: true
  validates :email, uniqueness: true
 
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauth_providers => [:google_oauth2]
 
  before_create :provide_dummy_names
  after_create :send_welcome_email
  before_destroy { |comment| current_user.privileged? }

  scope :match_users, lambda { |query, company_id| where('(LOWER(firstname) like ? OR LOWER(lastname) like ?) AND company_id = ? ', query, query, company_id).limit(5).pluck('id', 'firstname','lastname', 'avatar_file_name') }
  scope :extract_tags, lambda { |query, users| where('(CONCAT(LOWER(firstname), " ", LOWER(lastname)) like ?) AND id in (?)',  query, users).limit(5) }

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
  #     #[Fixed] - To give user a random name
  #     user.username = 'ViceLikePillow' + user.id.to_s
  #     #FIXME_AB: How would you handle if an exectpion is railsed by save!
  #     # [Fixed] - Using save instead
  #     user.save
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
    # [Fixed] - Removed self context
    if( is_admin? || is_moderator? || entity.try(:user) == self )
      return true
    else
      return false
    end
  end

  def set_api_token
    if(self == current_user)
      encrypter = Encrypt.new("soapBox key")
      self.consumer_key = encrypter.encrypt(self.email)
      self.consumer_secret = SecureRandom.hex
      self.save
    end
  end

  def self.manage_users(user, allowed_params)
    if(user.is_admin?)
      # CR_Priyank: Do we need User here
      # [Fixed] - Removed User
      return false unless allowed_params.is_a?(Hash)
      if(allowed_params[:to_ban].present?)
        begin
          transaction do 
            destroy_all(id: allowed_params[:to_ban].split)
            if(allowed_params[:make_moderators].present?)
              (allowed_params[:make_moderators] || []).split.each do |user_id|
                user = find_by(id: user_id)
                # CR_Priyank: move this to a method as we are using this in multiple places
                # [Fixed] - Not required as only used to make and remove moderators
                user.update_attributes(is_moderator: true)
              end
            end
          end
        rescue ActiveRecord::Rollback
          return false
        end
        true
      end
    end
  end

  def self.extract_users(group_id, company_id)
    if(group_id.blank?)
      all
    elsif(company_id.blank?) 
      Group.find_by(id: group_id).users
    else
      Company.find_by(id: company_id).groups.find_by(id: group_id).users
    end
  end 
  
  private

  def provide_dummy_names
    self.firstname = 'soapBox User'
    self.lastname = (User.last.try(:id) || 0 + 1).to_s
  end

  # CR_Priyank: Not a part of this model, move to concern
  # [Fixed] - move to notification concern

end
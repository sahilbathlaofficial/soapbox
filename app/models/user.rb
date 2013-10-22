class User < ActiveRecord::Base

  #FIXME_AB: What I am getting is, following connection is a company. If yes the we should name it as a company
  belongs_to :connection
  #FIXME_AB: Think about when a user is destroyed
  has_many :followings
  has_many :followees, through: :followings
  has_many :inverse_followings, class_name: 'Following', foreign_key: 'followee_id'
  has_many :followers, through: :inverse_followings, source: :user
  has_and_belongs_to_many :groups
  #FIXME_AB: We need a better way to handle a user's destroy. Please think and share how should we handle destroy of various entities
  has_many :groups_owned, foreign_key: 'admin_id', class_name: 'Group', dependent: :destroy
  #FIXME_AB: For ordering use scope
  has_many :posts, order: "created_at DESC", dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

#FIXME_AB: No need to use ActionController::Base.helpers.asset_path just pass 'missing.jpg' because in any way we will be using image_tag to display the image, which will take care of this
  has_attached_file :avatar, :styles => { :large=> "200x200>", :medium => "100x100>", :thumb => "25x25>" }, :default_url => ActionController::Base.helpers.asset_path('missing.png')

  validates :email, uniqueness: true
 
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauth_providers => [:google_oauth2]
 
  #attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :provider, :uid, :avatar
  # def self.from_omniauth(auth)
  #   if user = User.find_by_email(auth.info.email)
  #     user.provider = auth.provider
  #     user.uid = auth.uid
  #     user
  #   else
  #     where(auth.slice(:provider, :uid)).first_or_create do |user|
  #       user.provider = auth.provider
  #       user.uid = auth.uid
  #       user.username = auth.info.name
  #       user.email = auth.info.email
  #       user.avatar = auth.info.image
  #     end
  #   end
  # end

  def self.from_omniauth(access_token, signed_in_resource = nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first


    unless user
        user = User.create(email: data["email"],
             password: Devise.friendly_token[0,20],
             name: data["name"])
        #FIXME_AB: whay hardcoading username
        user.username = 'ViceLikePillow' + user.id.to_s
        #FIXME_AB: How would you handle if an exectpion is railsed by save!
        user.save!
    end
    user
  end

#FIXME_AB: following mehtod should be named as display_name as I guess will be used for display purpose only.
  def name
    firstname.capitalize + ' ' + lastname.capitalize
  end

end
class User < ActiveRecord::Base

  belongs_to :connection
  has_and_belongs_to_many :groups

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
        user.username = 'ViceLikePillow' + user.id.to_s
        user.save!
    end
    user
end

end
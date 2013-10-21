#FIXME_AB: You have a type column in groups table which is a convention for STI. Are you using STI. If not then why this type column is there an what is the use. There is no validation on this column
class Group < ActiveRecord::Base

  has_and_belongs_to_many :users
  #FIXME_AB: Since order is depricated in association, please make a scope
  has_many :posts, :order => "created_at DESC", dependent: :destroy
  belongs_to :connection
  belongs_to :admin, foreign_key:'admin_id', class_name: 'User'

  validates :name, presence: true
end

#FIXME_AB: What is the use of connection_id in groups table
#FIXME_AB: groups_users table need to have index infact a composit uniq index
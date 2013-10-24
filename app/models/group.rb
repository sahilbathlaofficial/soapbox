#FIXME_AB: You have a type column in groups table which is a convention for STI. Are you using STI. If not then why this type column is there an what is the use. There is no validation on this column
#FIX: to fix

class Group < ActiveRecord::Base

  has_and_belongs_to_many :users
  #FIXME_AB: Since order is depricated in association, please make a scope[Fixed]
  #FIX:Scope added
  has_many :posts, -> { order("created_at DESC") }, dependent: :destroy
  belongs_to :company
  belongs_to :admin, foreign_key:'admin_id', class_name: 'User'
  validates :name, :company_id, :admin_id, presence: true
  validates :name, uniqueness: { scope: [:company_id] }

  def admin?(user)
    self.admin == user
  end

end

#FIXME_AB: What is the use of company_id in groups table[Fixed]
#FIX: A group is unique in terms of a company 

#FIXME_AB: groups_users table need to have index infact a composit uniq index
#To fix
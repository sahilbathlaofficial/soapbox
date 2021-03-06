#FIXME_AB: You have a type column in groups table which is a convention for STI. Are you using STI. If not then why this type column is there an what is the use. There is no validation on this column
#[Fixed] - No type field in groups

class Group < ActiveRecord::Base

  include GlobalDataConcern
  # CR_Priyank: I think we must have dependent destroy in this association
  # [Fixed] - Ya right my bad
  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships
  
  # FIXME_AB: Since order is depricated in association, please make a scope[Fixed]
  # [Fixed] - Scope added
  has_many :posts, -> { order("created_at DESC") }, dependent: :destroy
  belongs_to :company
  belongs_to :admin, foreign_key:'admin_id', class_name: 'User'
  validates :name, :company_id, :admin_id, presence: true
  validates :name, uniqueness: { scope: [:company_id] }
  validates :name, format: { with: OnlyWordRegex, multiline: true }

  # CR_Priyank: This is not required, study has_many through thoroughly
  # [Fixed] - Changes made but not sure if correct
  after_create :create_membership_for_admin
  before_destroy :check_user_priviledge 
  
  scope :match_groups, lambda { |query, company_id| where('(LOWER(name) like ?) AND company_id = ?', query, company_id).limit(5).pluck('id', 'name') }

  def admin?(user)
    self.admin.id == user.id
  end

  def self.manage_groups(user, allowed_params)
    if(user.is_admin?)
      begin
        if(allowed_params.present?)
          return false unless allowed_params.is_a?(Hash)
          transaction do 
            (allowed_params[:to_ban] || []).split.each do |group_id|
              # CR_Priyank: What are we rescuing here ?
              # [Fixed] - Rescuing outside 
              find_by(id: group_id).destroy!
            end
          end
        end
      rescue ActiveRecord::Rollback
        # CR_Priyank: Indent properly
        # [Fixed] - Done so
        return false
      end
      true
    end
  end

  private

  def check_user_priviledge
    current_user.privileged?(self) 
  end

  def create_membership_for_admin
    if valid?
      users << admin
      group_memberships.first.approve 
    end
  end

end

#FIXME_AB: What is the use of company_id in groups table[Fixed]
#[FIXED] A group is unique in terms of a company 

#FIXME_AB: groups_users table need to have index infact a composit uniq index
#[Fixed] Made has_many through 
#FIXME_AB: put required validations[Fixed]
#[Fixed] company name would be present and unique 
class Company < ActiveRecord::Base
  has_many :users
  has_many :groups
  # CR_Priyank: I think we do not need to associate posts to company
  # [Fixed] - Removed the association
  validates :name, presence: true, uniqueness: {:case_sensitive => false}

  def self.manage_companies(user, allowed_params)
    if(user.is_admin?)
      Company.transaction do 
        # CR_Priyank: Use where instead of find
        # [Fixed] Using find_by instead
        # CR_Priyank: What if object is not destroyed ?
        # [Fixed] Case added for destroy error
        (allowed_params[:to_ban].split || []).each do |company_id|
          begin
            Company.find_by(id: company_id).destroy
          rescue ActiveRecord::Rollback
           return false
          end
        end
      end
    end
  end

end

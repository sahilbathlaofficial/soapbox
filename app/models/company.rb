#FIXME_AB: put required validations[Fixed]
#[Fixed] company name would be present and unique 
class Company < ActiveRecord::Base
  has_many :users
  has_many :groups

  validates :name, presence: true, uniqueness: {:case_sensitive => false}

  def self.manage_companies(user, allowed_params)
    if(user.is_admin?)
      begin
        if(allowed_params.present?)
          Company.transaction do 
            (allowed_params[:to_ban] || []).split.each do |company_id|
              # CR_Priyank: What are we rescuing here ?
              # [Fixed] - Rescued outside
              Company.find_by(id: company_id).destroy!
            end
          end
        end  
        true   
      rescue
        # CR_Priyank: Indent properly
        # [Fixed] Done so
        return false
      end
    end
  end

end

#FIXME_AB: put required validations[Fixed]
#FIX: company name would be present and unique 
class Company < ActiveRecord::Base
  has_many :users
  has_many :groups
  # CR_Priyank: I think we do not need to associate posts to company
  # [Fixed] - Removed the association
  validates :name, presence: true, uniqueness: {:case_sensitive => false}
end

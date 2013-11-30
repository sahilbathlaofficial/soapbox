#FIXME_AB: validations please[Fixed]
#[Fixed]: validations added
class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  validates :user_id, :post_id, presence: true
  validates :user_id, uniqueness: { scope: [:post_id] }
end

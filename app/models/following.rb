#FIXME_AB: Plase put required validtions in all models
# A user can follow other users at max 1 (therefore unique following )

#FIXME_AB: Please add required indexed in all tables
#To do
class Following < ActiveRecord::Base
  belongs_to :user
  belongs_to :followee, class_name: 'User'
  validates :user_id, uniqueness: { scope: [:followee_id] }
end

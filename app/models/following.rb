#FIXME_AB: Plase put required validtions in all models[Fixed]
# [Fixed] - A user can follow other users at max 1 (therefore unique following )

#FIXME_AB: Please add required indexed in all tables
# [To do]
class Following < ActiveRecord::Base
  include PublicActivity::Common
  include NotificationConcern

  belongs_to :user
  belongs_to :followee, class_name: 'User'
  validates :user_id, :followee_id, presence:true
  validates :user_id, uniqueness: { scope: [:followee_id] }
  after_create :notify_followee
end

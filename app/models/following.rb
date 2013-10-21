#FIXME_AB: Plase put required validtions in all models
#FIXME_AB: Please add required indexed in all tables
class Following < ActiveRecord::Base
  belongs_to :user
  belongs_to :followee, class_name: 'User'
end

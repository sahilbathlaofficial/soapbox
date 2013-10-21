#FIXME_AB: put required validations

class Connection < ActiveRecord::Base
  has_many :users
  has_many :groups
end

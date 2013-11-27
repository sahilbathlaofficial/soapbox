PublicActivity::Activity.class_eval do
  def self.fetch_notifications(user_id, seen = nil)
    if(seen.nil?)
      where('owner_id = ?', user_id).order('id desc')
    else
      where('owner_id = ? and seen = ?', user_id, seen)
    end
  end
end
module ApplicationHelper
  def fetch_group_names
    current_user.groups.limit 5 
  end
end

module ApplicationHelper
  def fetch_group_names
    current_user.groups.limit 5 
  end

  def fetch_members
    User.where(company: current_company).limit(7).order('created_at DESC')
  end

end

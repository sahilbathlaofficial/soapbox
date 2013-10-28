module ApplicationHelper
  def fetch_group_names
    current_user.groups.limit 5 
  end

  def fetch_members
    User.where(company: current_company).limit(6).order('created_at DESC')
  end

  def fetch_groups
    Group.where(company: current_company).limit(6).order('created_at DESC')
  end

end

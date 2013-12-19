module ApplicationHelper
  def fetch_group_names
    current_user.groups.limit 5 
  end

  def fetch_members
    User.where(company: current_company).limit(6).order('created_at DESC')
  end

  def fetch_groups(options)
    Group.includes(:group_memberships).where('groups.company_id = ? and group_memberships.user_id != ?', current_company.id, current_user.id).limit(options[:limit]).order('groups.created_at DESC').references(:group_memberships)
  end

end

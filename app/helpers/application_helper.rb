module ApplicationHelper
  def fetch_group_names(limit = 5)
    Group.where('connection_id = ?', session[:connection]).limit(5)
  end
end

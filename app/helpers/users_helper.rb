module UsersHelper
  def extract_viewable_posts(user, current_user)
    user.posts.where('group_id is ? or group_id in (?)', nil, current_user.groups)
  end
end
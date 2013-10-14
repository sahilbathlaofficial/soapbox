module GroupsHelper
  def extract_posts
    posts = @group.posts;
    posts.limit(5)
  end
end

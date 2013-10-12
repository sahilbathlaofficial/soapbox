module GroupsHelper
  def extract_posts
    @group.posts.limit 5 
  end
end

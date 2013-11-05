module PostsHelper
  def extract_tags_from_post(tags)
    tags_array = tags.split()
    User.where(id: tags_array)
  end
end

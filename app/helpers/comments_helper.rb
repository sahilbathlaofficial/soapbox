module CommentsHelper
  def extract_tags_from_comment(tags)
    tags_array = tags.split()
    User.where(id: tags_array)
  end
end

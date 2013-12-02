module CommentsHelper
  def extract_tags_from_comment(comment)
    tags_array = comment.tags.split
    tagged_users = User.where(id: tags_array)
    for user in tagged_users
      comment.content.gsub!(/#{user.name}/i) {|user_name|  link_to(user_name, user_path(id: user.id), class: 'tags') }
    end 
    comment.content
  end
end

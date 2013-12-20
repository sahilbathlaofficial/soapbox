ThinkingSphinx::Index.define :post, :delta =>true, :with => :active_record do
  indexes content
  indexes [user.firstname, user.lastname], :as => :post_author
  indexes comments.content, :as => :comment_content
  indexes [comments.user.firstname, comments.user.lastname], :as => :comment_author
end
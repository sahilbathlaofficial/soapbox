ThinkingSphinx::Index.define :post, :with => :active_record do
  indexes content
  indexes comments.content, :as => :comment_content
end
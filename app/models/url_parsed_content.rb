class URLParsedContent < ActiveRecord::Base
  belongs_to :post
  validates :url, format: URLRegex
  validates :post_id, presence: true
end

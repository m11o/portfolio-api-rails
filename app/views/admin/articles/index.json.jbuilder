# frozen_string_literal: true

json.array! @articles do |article|
  json.extract! article, :handle, :title, :description, :published_at
  json.url admin_article_url(article, format: :json)
end

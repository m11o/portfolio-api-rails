# frozen_string_literal: true

json.extract! article, :handle, :title, :description, :body, :published_at
json.url article_url(article, format: :json)

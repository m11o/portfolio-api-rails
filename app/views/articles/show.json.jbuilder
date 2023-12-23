# frozen_string_literal: true

json.extract! article, :handle, :title, :description, :published_at
json.body article.body_html

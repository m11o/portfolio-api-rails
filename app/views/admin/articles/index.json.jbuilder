# frozen_string_literal: true

json.array! @articles do |article|
  json.extract! article, :handle, :title, :published_at
end

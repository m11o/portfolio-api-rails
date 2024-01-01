# frozen_string_literal: true

class Article < FirestoreRecordBase
  collection_name 'articles'

  attribute :title, :string
  attribute :description, :string
  attribute :body, :string
  attribute :published_at, :datetime

  validates :title, presence: true
  validates :body, presence: true
end

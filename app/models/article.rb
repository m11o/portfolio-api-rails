# frozen_string_literal: true

class Article < ApplicationRecord
  validates :handle, presence: true, uniqueness: { case_sensitive: true }
  validates :title, presence: true
  validates :body, presence: true

  before_validation :generate_handle

  scope :publish, -> { where(Article.arel_table[:published_at].lteq(Time.zone.now)) }

  private

  def generate_handle
    return if handle.present?

    handle = SecureRandom.alphanumeric(12).upcase
    return generate_handle if Article.exists?(handle: handle)

    self.handle = handle
  end
end

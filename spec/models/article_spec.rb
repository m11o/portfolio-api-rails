# frozen_string_literal: true

require 'rails_helper'

describe Article, type: :model do
  describe 'callback' do
    describe 'before_validation generate_handle' do
      it 'handleが動的に作成されること' do
        article = build(:article, handle: nil)
        article.valid?
        expect(article.handle).to be_present
      end

      it '大文字英数字12桁の文字列が入ること' do
        article = build(:article, handle: nil)
        article.valid?
        expect(article.handle).to match(/\A[A-Z0-9]{12}\z/)
      end

      it 'すでにhandleが登録されている場合、handleは元の値のままであること' do
        article = build(:article, handle: 'ABCDEF123456')
        article.valid?
        expect(article.handle).to eq 'ABCDEF123456'
      end
    end
  end
end

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

  describe '.publish' do
    around do |example|
      freeze_time { example.run }
    end

    before do
      create(:article, published_at: 1.second.ago, handle: 'ABC111111111')
      create(:article, published_at: Time.zone.now, handle: 'ABC222222222')
      create(:article, published_at: 1.second.from_now, handle: 'ABC333333333')
    end

    it '現在時刻よりpublished_atが小さいのみ選択できる' do
      expect(Article.publish.pluck(:handle)).to match_array(%w[ABC111111111 ABC222222222])
    end
  end
end

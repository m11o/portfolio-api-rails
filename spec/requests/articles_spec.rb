# frozen_string_literal: true

require 'rails_helper'

describe ArticlesController, type: :request do
  describe 'GET /articles' do
    subject { get '/articles.json', headers: headers }

    let!(:headers) { { Authorization: 'Bearer token' } }
    let!(:article) { create(:article) }

    it '200が返ること' do
      is_expected.to eq 200
    end

    context 'api_tokenが異なる値の場合' do
      let!(:headers) { { Authorization: 'Bearer another_token' } }

      it '401が返ること' do
        is_expected.to eq 401
      end
    end
  end

  describe 'GET /articles/:handle' do
    subject { get "/articles/#{article.handle}.json", headers: headers }

    let!(:headers) { { Authorization: 'Bearer token' } }
    let!(:article) { create(:article) }

    it '200が返ること' do
      is_expected.to eq 200
    end

    context 'api_tokenが異なる値の場合' do
      let!(:headers) { { Authorization: 'Bearer another_token' } }

      it '401が返ること' do
        is_expected.to eq 401
      end
    end

    context '存在しない記事の場合' do
      subject { get '/articles/HOGE.json', headers: headers }

      it '404が返ること' do
        is_expected.to eq 404
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe Admin::ArticlesController, type: :request do
  describe 'GET /admin/articles.json' do
    subject { get '/admin/articles.json', headers: headers }

    let!(:headers) { { Authorization: 'Bearer token' } }
    let!(:article) { create(:article) }

    it '200が返る' do
      is_expected.to eq 200
    end

    context '不正なAPIトークンの場合' do
      let!(:headers) { { Authorization: 'Bearer another_token' } }

      it '401が返る' do
        is_expected.to eq 401
      end
    end
  end

  describe 'GET /admin/articles/:handle' do
    subject { get "/admin/articles/#{article.handle}.json", headers: headers }

    let!(:headers) { { Authorization: 'Bearer token' } }
    let!(:article) { create(:article) }

    it '200が返る' do
      is_expected.to eq 200
    end

    context '不正なAPIトークンの場合' do
      let!(:headers) { { Authorization: 'Bearer another_token' } }

      it '401が返る' do
        is_expected.to eq 401
      end
    end

    context '存在しない記事の場合' do
      subject { get '/admin/articles/HOGE.json', headers: headers }

      it '404が返ること' do
        is_expected.to eq 404
      end
    end
  end

  describe 'POST /admin/articles.json' do
    subject { post '/admin/articles.json', params: params, headers: headers }

    let!(:headers) { { Authorization: 'Bearer token' } }
    let!(:params) do
      {
        article: {
          title: 'title',
          description: 'description',
          body: 'body',
          published_at: 2.days.from_now
        }
      }
    end

    it '200が返る' do
      is_expected.to eq 200
    end

    it '記事が一つ作成される' do
      expect { subject }.to change(Article, :count).by(1)
    end

    context 'バリデーションエラーの場合' do
      let!(:params) do
        {
          article: {
            title: nil,
            description: 'description',
            body: 'body',
            published_at: 2.days.from_now
          }
        }
      end

      it '422が返る' do
        is_expected.to eq 422
      end

      it '記事が作成されない' do
        expect { subject }.not_to change(Article, :count)
      end
    end

    context '不正なAPIトークンの場合' do
      let!(:headers) { { Authorization: 'Bearer another_token' } }

      it '401が返る' do
        is_expected.to eq 401
      end
    end
  end

  describe 'PUT /admin/articles/:handle.json' do
    subject { put "/admin/articles/#{article.handle}.json", params: params, headers: headers }

    let!(:headers) { { Authorization: 'Bearer token' } }
    let!(:params) do
      {
        article: {
          title: 'title'
        }
      }
    end
    let!(:article) { create(:article) }

    it '200が返る' do
      is_expected.to eq 200
    end

    it '記事タイトルが更新されること' do
      expect { subject }.to change { article.reload.title }.to('title')
    end

    context 'バリデーションエラーの場合' do
      let!(:params) do
        {
          article: {
            title: nil
          }
        }
      end

      it '422が返る' do
        is_expected.to eq 422
      end

      it '記事が更新されないこと' do
        expect { subject }.not_to(change { article.reload.title })
      end
    end

    context '不正なAPIトークンの場合' do
      let!(:headers) { { Authorization: 'Bearer another_token' } }

      it '401が返る' do
        is_expected.to eq 401
      end
    end
  end

  describe 'DELETE /admin/articles/:handle.json' do
    subject { delete "/admin/articles/#{article.handle}.json", headers: headers }

    let!(:headers) { { Authorization: 'Bearer token' } }
    let!(:article) { create(:article) }

    it '200が返る' do
      is_expected.to eq 200
    end

    it '記事が削除されること' do
      expect { subject }.to change(Article, :count).by(-1)
    end

    context '削除に失敗した場合' do
      before do
        allow_any_instance_of(Article).to receive(:destroy!).and_raise(StandardError)
      end

      it '422が返る' do
        is_expected.to eq 422
      end

      it '記事が削除されないこと' do
        expect { subject }.not_to change(Article, :count)
      end
    end

    context '不正なAPIトークンの場合' do
      let!(:headers) { { Authorization: 'Bearer another_token' } }

      it '401が返る' do
        is_expected.to eq 401
      end
    end
  end
end

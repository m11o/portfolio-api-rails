# frozen_string_literal: true

module Admin
  class ArticlesController < ApplicationController
    before_action :set_article, only: %i[show update destroy]

    def index
      # TODO: set pagination
      @articles = Article.all
    end

    def show; end

    def create
      @article = Article.new article_params
      if @article.save
        render :show, status: :ok
      else
        render json: { messages: @article.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @article.save
        render :show, status: :ok
      else
        render json: { messages: @article.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @article.destroy!
      render :index, status: :ok
    rescue StandardError => e
      render json: { messages: [e.message] }, status: :unprocessable_entity
    end

    private

    def set_article
      @article = Article.find_by! params[:handle]
    end

    def article_params
      params.require(:article).permit(:title, :description, :body, :published_at)
    end
  end
end

# frozen_string_literal: true

module Admin
  class ArticlesController < ApplicationController
    include Md2Html

    before_action :set_article, only: %i[show update destroy]

    def index
      # TODO: set pagination
      @articles = Article.all
    end

    def show; end

    def create
      @article = Article.new article_params
      @article.body_html = md2html(@article.body)

      if @article.save
        render :show, status: :ok
      else
        render json: { messages: @article.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      @article.assign_attributes article_params
      @article.body_html = md2html(@article.body)

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
      @article = Article.find_by! handle: params[:handle]
    end

    def article_params
      params.require(:article).permit(:title, :description, :body, :published_at)
    end
  end
end

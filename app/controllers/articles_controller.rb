# frozen_string_literal: true

class ArticlesController < ApplicationController
  # GET /articles.json
  def index
    # TODO: set pagination
    # TODO: ransack
    @articles = Article.all
  end

  # GET /articles/1.json
  def show
    @article = Article.find_by! handle: params[:handle]
  end
end
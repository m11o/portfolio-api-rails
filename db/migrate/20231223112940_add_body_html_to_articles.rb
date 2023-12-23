class AddBodyHtmlToArticles < ActiveRecord::Migration[7.1]
  def change
    add_column :articles, :body_html, :text, limit: 16777215
  end
end

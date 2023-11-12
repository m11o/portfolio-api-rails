class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :articles do |t|
      t.string   :handle, null: false, index: { unique: true }
      t.string   :title, null: false
      t.string   :description
      t.text     :body, null: false, limit: 16777215
      t.datetime :published_at

      t.timestamps
    end
  end
end

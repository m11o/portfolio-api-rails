# frozen_string_literal: true

module Md2Html
  def md2html(markdown)
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::Safe, autolink: true, tables: true)
    renderer.render(markdown)
  end
end

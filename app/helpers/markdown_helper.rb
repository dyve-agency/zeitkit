module MarkdownHelper
  def markdown(markdown_text)
    return if !markdown_text
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(markdown_text).html_safe
  end
end

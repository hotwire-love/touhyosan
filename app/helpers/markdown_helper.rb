# app/helpers/markdown_helper.rb
module MarkdownHelper
  def markdown(text)
    return '' if text.blank?

    renderer = Redcarpet::Render::HTML.new(
      hard_wrap: true,
      filter_html: true,
      link_attributes: { target: '_blank', rel: 'nofollow' }
    )
    markdown = Redcarpet::Markdown.new(
      renderer,
      autolink: true,
      no_intra_emphasis: true,
      tables: true
    )

    # sanitize(markdown.render(text))
    markdown.render(text).html_safe
  end
end

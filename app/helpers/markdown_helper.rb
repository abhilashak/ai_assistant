module MarkdownHelper
  def render_markdown(text)
    html = Commonmarker.to_html(text.to_s)

    sanitize(
      html,
      tags: %w[
        p
        br
        strong
        em
        del
        h1
        h2
        h3
        h4
        ul
        ol
        li
        blockquote
        pre
        code
        a
      ],
      attributes: %w[href title]
    )
  end
end

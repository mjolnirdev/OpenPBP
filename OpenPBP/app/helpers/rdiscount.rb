def rd(content)
  markdown = RDiscount.new(content, :smart, :filter_html, :filter_styles, :footnotes, :no_pseudo_protocols, :safelink, :autolink)
  markdown.to_html
end
module BodyFormatter

  def format_body(text)
    text = text.to_s # copy
    escape_lts!(text)
    cleanup_newlines!(text)
    encode_leading_blank_chars!(text)
    format_quotes!(text)
    format_paragraphs!(text)
    text
  end
  
  def escape_lts!(text)
    text.gsub!('<', '&lt;')
  end
  
  def cleanup_newlines!(text)
    text.gsub!(/\r\n?/, "\n")
    text.gsub!(/\n{3,}/, "\n\n")
  end
  
  def encode_leading_blank_chars!(text)
    text.gsub!(/^(\s+)/) { |blank_chars| blank_chars.gsub(' ', '&nbsp;') }    
  end
  
  def format_quotes!(text)
    text.gsub!(/^(>.*?)$^($|[^>])/m) do |quote| 
      quote.gsub!(/^(>\s?)/, '')
      quote << "\n"
      format_quotes!(quote)
      "<blockquote>#{quote}</blockquote>"
    end
  end
  
  def format_paragraphs!(text)
    text.gsub!("\n\n", '</p><p>')
    text.gsub!("\n", '<br />')
    text.insert(0, '<p>')
    text << '</p>'
  end
  
end
module TopicsHelper
  
  include Paginate::ViewHelper
  
  # TODO: could be improved, maybe by a line oriented parser
  def render_message_body(body)
    text = body.to_s.strip
    text.gsub!(/\r\n?/, "\n")
    text.gsub!(/\n{3,}/, "\n\n")
    #text.gsub!(/^>.*\Z/m, '') # remove quotes # TODO: maybe surround them by a quote tag with toogle display
    text.gsub!(/(\s+)$/, '') # remove trailing blank chars
    text.gsub!(/^(\s+)/) { |blank_chars| blank_chars.gsub(' ', '&nbsp;') }    
    text.gsub!(/\n.*?:\s*\Z/,  "\n")     # remove top posters's "xxx wrote" like lines
    text.gsub!(/\s*(<\/?[a-z]+>)\s*/, '\1')
    text.gsub!("\n\n", '</p><p>')
    text.gsub!("\n", '<br />')
    text.insert(0, '<p>') if text.at(0) != '<'
    text << '</p>' unless text.ends_with?('>')
    text
  end
  
end
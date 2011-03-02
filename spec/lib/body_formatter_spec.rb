require 'spec_helper'

describe BodyFormatter do
  
  include BodyFormatter
  
  describe '.cleanupd_newlines!' do
    
    it 'should replace \r and \r\n by real \n' do
      text = "Hello\rWorld\r\nHow\ndo you do ?"
      cleanup_newlines!(text)
      text.should == "Hello\nWorld\nHow\ndo you do ?"
    end
    
    it 'should reduce 3 or more continious linebreak to 2' do
      text = "Hello\n\n\n\n\nWorld\n\n"
      cleanup_newlines!(text)
      text.should == "Hello\n\nWorld\n\n"
    end
    
  end
  
  describe '.encode_leading_blank_chars!' do
    
    it 'should replace leading blank chars by &nbsp;' do
      text = "def foo\n  puts 'foo'\nend"
      encode_leading_blank_chars!(text)
      text.should == "def foo\n&nbsp;&nbsp;puts 'foo'\nend"
    end
    
  end
  
  describe '.format_quotes!' do
    
    it 'should not repeat last letter' do
      text = "> Hey"
      format_quotes!(text)
      text.should == '<blockquote>Hey</blockquote>'
    end
    
    it 'should surround quotes with <blockquote> tags' do
      text = %{Hi,

> This is a quote
> on multiple lines

Sure it is !
}
      format_quotes!(text)
      text.should == "Hi,\n\n<blockquote>This is a quote\non multiple lines</blockquote>Sure it is !\n"
    end
    
    it 'hande quotes of quotes' do
      text = ">> Hello\n> Hi !\nHey !"
      format_quotes!(text)
      text.should == "<blockquote><blockquote>Hello</blockquote>Hi !</blockquote>Hey !"
      
      text = %{Hi,
> Hello
>> This is a quote of quote
>> on multiple lines

Sure it is !
}
      format_quotes!(text)
      text.should == "Hi,\n<blockquote>Hello\n<blockquote>This is a quote of quote\non multiple lines</blockquote></blockquote>Sure it is !\n"
    end
    
  end
  
  describe '.format_paragraphs!' do
    
    it 'should surround paragraphs with <p>' do
      text = %Q{Hi,
This is a paragraph.

This is a oneline paragraph.
}
      format_paragraphs!(text)
      text.should == "<p>Hi,<br />This is a paragraph.</p><p>This is a oneline paragraph.<br /></p>"
    end
    
  end
  
  describe '.suround_signatures!' do
    
    it 'should suround the smallest signature' do
      text = %{Hello
World

-- Some SQL
SELECT * FROM foos;

--
Superman
http://foo.com/}
      suround_signatures!(text)
      text.should == "Hello\nWorld\n\n-- Some SQL\nSELECT * FROM foos;\n\n<div class=\"signature\">--\nSuperman\nhttp://foo.com/</div>"
    end
    
  end
  
end

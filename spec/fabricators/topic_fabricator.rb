Fabricator :topic do
  
  groups %w(comp.lang.ruby)
  
  message_id '12345@troll.com'
  subject "Ruby sucks !"
  author_name "Hebus The Troll"
  author_email "hebus@example.com"
  body %{I've just made a benchmark, Ruby is 13.5 times slower than C. This is so lame !}
  created_at DateTime.new(2010, 1, 12, 9, 50, 36)

  # child_messages do
  #   [Fabricate.build(:message)]
  # end
  
  after_create do |topic|
    
    first_response = topic.child_messages << Fabricate.build(:message,
      :message_id => '23456@troll.com',
      :subject => "Re: Ruby sucks !",
      :body => %{I can't figure out if you'r a troll or if you'r just totaly dumb.}
    )

    topic.child_messages.first.child_messages << Fabricate.build(:message,
      :message_id => '34567@troll.com',
      :subject => "Re: Ruby sucks !",
      :body => %{If you don't trust me jsut try yourself:
        
        hello.c:
        
          #include <stdio.h>

          int main(int argc, char *argv[])
          {
              puts("Hello world!");
              return 0;
          }
        
        versus
        
        hello.rb:
        
          #!/usr/bin/ruby
          
          puts "Hello world"
        
      }
    )
    
    topic.child_messages.first.child_messages << Fabricate.build(:message,
      :message_id => '45678@troll.com',
      :subject => "Re: Ruby sucks !",
      :body => %{Don't feed the troll !}
    )
    
  end
  
end

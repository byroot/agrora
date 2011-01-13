Fabricator :topic do
  
  groups %w(comp.lang.ruby)
  
  message do
    Fabricate.build(:message)
  end
  
  after_build do |topic|
    
    first_response = topic.message.responses << Fabricate.build(:message,
      :message_id => '23456@troll.com',
      :subject => "Re: Ruby sucks !",
      :body => %{I can't figure out if you'r a troll or if you'r just totaly dumb.}
    )
    
    second_response = topic.message.responses << Fabricate.build(:message,
      :message_id => '45678@troll.com',
      :subject => "Re: Ruby sucks !",
      :body => %{Don't feed the troll !}
    )

    topic.message.responses.first.responses << Fabricate.build(:message,
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
    
  end
  
end

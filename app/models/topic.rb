class Topic < RootNode
  
  include Content
  
  class << self
    
    def create_from_message!(message, groups)
      create!(message.attributes.merge(:groups => groups))
    end
    
  end
  
end

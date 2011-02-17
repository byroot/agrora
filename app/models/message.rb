class Message < Node
  
  include Content
  
  alias :index :_index
  
  attr_accessor :groups
  
  private
  
  def to_param
    index.to_s
  end
  
end
class NNTPClient

  class Group

    attr_reader :name, :first, :last

    def initialize(name, first=0, last=0)
      @name = name
      @first = first.to_i
      @last = last.to_i
    end

    def to_s
      @name
    end
  
  end
  
end

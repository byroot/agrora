module Jobs
  class Base
    
    def self.perform(*args)
      self.new(*args).perform!
    end
    
    protected
    
    def client
      @client ||= NNTPClient.new(
        server.hostname,
        server.port,
        server.user,
        server.secret
      )
    end
    
  end
end
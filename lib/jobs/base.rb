module Jobs
  class Base
    
    def self.perform(*args)
      self.new(*args).perform!
    end
    
    protected
    
    def on_each_server
      servers.each{ |server| yield build_client(server) }
    end
    
    def build_client(server)
      NNTPClient.new(
        server.hostname,
        server.port,
        server.user,
        server.secret
      )
    end
    
  end
end
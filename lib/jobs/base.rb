module Jobs
  class Base
    
    def self.perform(*args)
      self.new(*args).perform!
    end
    
    protected
    
    [:debug, :info, :error, :warning].each do |method|
      class_eval %Q{
        def #{method}(message)
          Rails.logger.#{method}("[\#{self.class.name}] \#{message}")
        end
      }
    end
    
    def on_each_server
      servers.each do |server| 
        info "With server #{server.hostname}"
        begin
          yield build_client(server)
        rescue NNTPClient::NNTPException => exc
          error exc.message
        end
      end
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
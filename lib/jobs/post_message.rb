require 'resque/plugins/lock'

module Jobs
  class PostMessage < Jobs::Base
    
    @queue = 'nntp'
    
    extend Resque::Plugins::Lock
    
    def initialize(indexes)
      @topic = Topic.where(:index => indexes.first).first
      @message = @topic.find_message_by_indexes(message_indexes)
    end
    
    def perform!
      on_each_server do |client|
        info "Start posting message #{@message.indexes.join('-')}"
        begin
          return client.post(build_message.to_s)
        rescue NNTPClient::NNTPException => exc
          @exception = exc
        end
      end
      raise @exception
    end
    
    def build_message
      Mail.new({
        :subject => @message.subject,
        :message_id => "<#{@message.message_id}>",
        :references => @message.references.map{ |id| "<#{id}>" }.join(' '),
        :from => build_from,
        :date => @message.created_at,
        :body => @message.body,
        :newsgroups => @topic.groups.join(',')
      })
    end
    
    def build_from
      Mail::Address.new.tap do |a|
        a.address = @message.author_email
        a.display_name = @message.author_name
      end.to_s
    end
    
    protected
    
    def servers
      @server ||= Group.where(:name => @topic.groups.first).map(&:servers).uniq
    end
    
  end
end
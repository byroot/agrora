require 'resque/plugins/lock'

module Jobs
  class PostMessage < Jobs::Base
    
    @queue = 'nntp'
    
    extend Resque::Plugins::Lock
    
    def initialize(topic_index, message_indexes)
      @topic = Topic.where(:index => topic_index).first
      @message = @topic.find_message_by_indexes(message_indexes)
    end
    
    def perform!
      client.post(build_message.to_s)
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
    
    def server
      @server ||= Group.where(:name => @topic.groups.first).first.server
    end
    
  end
end
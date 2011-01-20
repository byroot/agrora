require 'resque/plugins/lock'

module Jobs
  class UpdateGroup
    
    extend Resque::Plugins::Lock
    
    def self.perform(group_name)
      self.new(group_name).perform!
    end
    
    def initialize(group_name)
      @group_name = group_name
    end
    
    def perform!
      client.group(group.name)
      client.each_article_since(group.name, group.last_synchronisation_at) do |article|
        begin
          message = build_message(article)
          insert_message(message, article.newsgroups.groups)
          group.update_attributes(:last_synchronisation_at => message.created_at)
        rescue Exception => e
          puts "#{e.class.name}: #{e.message}"
          puts e.backtrace
          puts '-' * 40
          puts article.to_s
        end
      end
      
    end
    
    def build_message(article)
      Message.new(
        :message_id => article.message_id,
        :references => article[:references].try(:message_ids),
        :subject => article.subject,
        :body => article.body,
        :created_at => article.date
      )
    end
    
    def insert_message(message, groups)
      if message.references.any? && topic = Topic.where(:root => message.root).first
        topic.insert_or_update_message(message)
      else
        Topic.create_from_message!(message, groups)
      end
    end
    
    def group
      @group ||= Group.where(:name => @group_name).first
    end
    
    def client
      @client ||= NNTPClient.new(
        group.server.hostname,
        group.server.port,
        group.server.user,
        group.server.secret
      )
    end
    
  end
end
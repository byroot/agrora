require 'resque/plugins/lock'

module Jobs
  class UpdateGroup < Jobs::Base
    
    @queue = 'nntp'
    
    ENCODING_ALIASES = {'utf8' => 'UTF-8'}.freeze
    
    extend Resque::Plugins::Lock
    
    delegate :server, :to => :group
    
    def initialize(group_name)
      @group_name = group_name
    end
    
    def perform!
      on_each_server do |client|
        begin
          client.group(group.name)
          client.each_article_since(group.name, group.last_synchronisation_at) do |article|
            begin
              message = build_message(article)
              insert_message(message, article.newsgroups.groups)
            rescue Exception => e
              puts "#{e.class.name}: #{e.message}"
              puts e.backtrace
              puts '-' * 40
              puts article.to_s
            end
          end
          group.update_attributes(:last_synchronisation_at => DateTime.now)
          return
        rescue NNTPClient::NNTPException => exc
          @exception = exc
        end
      end
      raise @exception
    end
    
    def build_message(article)
      Message.new(
        :author_name => article[:from].display_names.first,
        :author_email => article[:from].addresses.first,
        :message_id => article.message_id,
        :references => article[:references].try(:message_ids),
        :subject => article.subject,
        :body => utf8_body(article),
        :created_at => article.date
      )
    end
    
    def utf8_body(article)
      body = article.body.decoded
      if body_encoding = encoding(article)
        body = body.force_encoding(body_encoding)
      end
      body.encode('UTF-8')
    end
    
    def encoding(article)
      claimed_encoding = article['content-type'].try(:parameters).try(:[], 'charset')
      ENCODING_ALIASES[claimed_encoding] || claimed_encoding
    end
    
    def insert_message(message, groups)
      if message.references.any? && topic = Topic.where(:root => message.root).first
        topic.insert_or_update_message(message)
      else
        Topic.create_from_message!(message, groups)
      end
    end
    
    def servers
      group.servers
    end
    
    def group
      @group ||= Group.where(:name => @group_name).first
    end
    
  end
end
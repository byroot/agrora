require 'resque/plugins/lock'

module Jobs
  class UpdateGroup < Jobs::Base
    
    @queue = 'nntp'
    
    ENCODING_ALIASES = {'utf8' => 'UTF-8'}.freeze
    
    extend Resque::Plugins::Lock
    
    def initialize(group_name)
      @group_name = group_name
    end
    
    def perform!
      on_each_server do |client|
        begin
          client.group(group.name)
          client.each_article_since(group.name, group.last_synchronisation_at) do |article|
            begin
              info 'Start processing article'
              store!(build_message(article))
              info 'Success'
            rescue Exception => e
              error "#{e.class.name}: #{e.message}"
              error error e.backtrace
              error '-' * 40
              error article.to_s
            end
          end
          group.update_attributes(:last_synchronisation_at => DateTime.now)
          return
        rescue NNTPClient::NNTPException => exc
          @exception = exc
        end
      end
      raise @exception || "No available server"
    end
    
    def store!(message)
      if message.references.empty?
        node = RootNode.find_or_initialize_by(:message_id => message.message_id)
        node.as!(Topic, message.attributes.merge(:groups => message.groups))
      else
        root, *references = message.references
        node = RootNode.find_or_create_by(:message_id => root, :groups => message.groups)
        references.each do |message_id|
          node = node.child_nodes.find_or_create_by(:message_id => message_id)
        end
        node = node.child_nodes.find_or_initialize_by(:message_id => message.message_id)
        node.as(Message, message.attributes.merge(:parent_node => node.parent_node)).save!
      end
    end
    
    def build_message(article)
      Message.new(
        :groups => article.newsgroups.groups,
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
    
    def servers
      group.servers
    end
    
    def group
      @group ||= Group.where(:name => @group_name).first
    end
    
  end
end
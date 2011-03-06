require 'nntp'

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
  
  NNTPException = Class.new(Exception)
  
  UnknowGroupException = Class.new(NNTPException)
  
  UnknowArticleException = Class.new(NNTPException)
  
  NetworkFailureException = Class.new(NNTPException)
  
  def initialize(host='localhost', port=119, user=nil, secret=nil, method=nil)
    @nntp = Net::NNTP.start(host, port, user, secret, method)
  rescue SystemCallError => e
    raise NetworkFailureException.new(e.message)
  end
  
  def post(article)
    @nntp.post(article.to_s)
  end
  
  def article(id=nil)
    response = @nntp.article id
    Mail.new(response[1].join("\n")) if response.size > 1
  rescue Net::NNTPServerBusy => e
    raise UnknowArticleException.new(e.message)
  end
  
  def list
    groups = @nntp.list[1]
    groups.each_with_object([]) do |line, listgroup|
      if line.match /^([^\s]+)\s+(\d)+\s+(\d+)/
        listgroup << NNTPClient::Group.new($1, $3, $1)
      end
    end
  end
  
  def group(group_name)
    @nntp.group group_name
  rescue Net::NNTPServerBusy => e
    raise UnknowGroupException.new(e.message)
  end
  
  def closed?
    !@nntp.started?
  end
  
  def close
    @nntp.finish
  end
  
  def over
  end
  
  # each_article start iteration on current article on the selected group
  # at the end the cursor is not rewind
  def each_article
    begin
      yield article
    end while self.next
  end
  
  def next
    parse_iter_response @nntp.next
  rescue Net::NNTPServerBusy => e
    nil
  end
  
  def last
    parse_iter_response @nntp.last
  rescue Net::NNTPServerBusy => e
    nil
  end
  
  def each_article_since(group, datetime) # TODO: add this command in nntp gem
      date = datetime.strftime('%Y%m%d')
      time = datetime.strftime('%H%M%S')
      result = @nntp.newnews(group, date, time)
      result.last.each do |id|
        current = article(id)
        yield current
      end
  end
  
  private
  
  def parse_iter_response(response)
    response[1].match /(\d+)\s+<(.*)>/i
    {'idx' => $1, 'message-id' => $2}
  end

end


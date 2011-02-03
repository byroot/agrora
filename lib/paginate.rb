module Paginate
  
  module ControllerExtension
    
    attr_reader :paginator
    
    protected
    
    def paginate(scope, options={})
      @paginator = Paginator.new(self, scope, options)
      paginator.scope
    end
    
  end
  
  module ViewHelper
    
    def self.included(base)
      base.delegate :paginator, :to => :controller
    end
    
  end
  
  class Paginator
    
    DEFAULT_PER_PAGE = 20
    
    attr_reader :controller, :base_scope, :options
    
    def initialize(controller, base_scope, options)
      @controller = controller
      @base_scope = base_scope
      @options = options
    end
    
    def scope
      base_scope.paginate(:page => page, :per_page => per_page)
    end
    
    def per_page
      (controller.params[:per_page] || options[:per_page] || DEFAULT_PER_PAGE).to_i
    end
    
    def page
      (controller.params[:page] || 1).to_i
    end
    
    def pages_count
      items_count = base_scope.count
      pages_count = items_count / per_page
      pages_count += 1 unless (items_count % per_page) == 0
      pages_count
    end
    
    def last?
      page == pages_count
    end
    
    def first?
      page <= 1
    end
    
    def first_page_url
      page_url(1)
    end
    
    def last_page_url
      page_url(pages_count)
    end
    
    def shift_page_url(offset)
      page_url(page + offset)
    end
    
    def previous_page_url
      shift_page_url(-1)
    end
    
    def next_page_url
      shift_page_url(1)
    end
    
    def page_url(index)
      controller.url_for(controller.params.merge(:page => index))
    end
    
  end
  
end